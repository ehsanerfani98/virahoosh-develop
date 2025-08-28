import os
import pandas as pd
import logging
import shutil
import uuid
from typing import List, Tuple

from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from langchain.schema import Document
from langchain.text_splitter import RecursiveCharacterTextSplitter

from database.session import SessionLocal
from models.assistant import Assistant
from celery_app import celery_app
from celery import chord

# ==============================
# تنظیمات و ثابت‌ها
# ==============================
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)

# حداکثر اندازه‌ی قابل قبول برای محتوای هر سلول (کاراکتر)
MAX_CELL_CHARS = 50_000

# هدف تعداد چانک (اگر خیلی زیاد شد، chunk_size را بزرگ می‌کنیم تا به این حدود برسد)
TARGET_MAX_CHUNKS = 5_000

# سقف سخت برای تعداد چانک‌ها (اگر بعد از تنظیم خودکار هنوز بیشتر بود، خطا می‌دهیم)
HARD_MAX_CHUNKS = 25_000

# اندازه‌ی اولیه‌ی چانک و همپوشانی
DEFAULT_CHUNK_SIZE = 1000
DEFAULT_CHUNK_OVERLAP = 200

# نام ستون‌ها در اکسل
QUESTION_COL = "سوال"
ANSWER_COL = "پاسخ"


# ==============================
# توابع کمکی
# ==============================
def get_user_path(user_id: str) -> str:
    return os.path.join("static", "uploads", f"user_{user_id}")


def normalize_text(text: str) -> str:
    """تبدیل اعداد فارسی به لاتین + strip."""
    if text is None:
        return ""
    mapping = str.maketrans("۰۱۲۳۴۵۶۷۸۹", "0123456789")
    return str(text).translate(mapping).strip()


def ensure_dir(path: str) -> None:
    os.makedirs(path, exist_ok=True)
    try:
        os.chmod(path, 0o755)
    except Exception:
        # روی برخی سیستم‌ها (مثل ویندوز) ممکن است خطا بدهد، اهمیتی ندارد
        pass


def truncate_if_needed(s: str, max_len: int = MAX_CELL_CHARS) -> Tuple[str, bool]:
    if len(s) > max_len:
        return s[:max_len], True
    return s, False


def build_splitter(chunk_size: int, chunk_overlap: int) -> RecursiveCharacterTextSplitter:
    # استفاده از جداکننده‌ها برای جلوگیری از recursion بی‌نتیجه
    return RecursiveCharacterTextSplitter(
        chunk_size=chunk_size,
        chunk_overlap=chunk_overlap,
        separators=["\n\n", "\n", " ", ""],  # از بزرگ به کوچک
        length_function=len,
        keep_separator=False,
    )


def dynamic_split_documents(docs: List[Document]) -> List[Document]:
    """
    تلاش می‌کند با chunk_size پویا، تعداد چانک‌ها را در محدوده‌ی سالم نگه دارد.
    اگر تعداد چانک‌ها خیلی زیاد شد، chunk_size را بزرگ‌تر می‌کنیم و دوباره split می‌کنیم.
    """
    chunk_size = DEFAULT_CHUNK_SIZE
    overlap = DEFAULT_CHUNK_OVERLAP

    # مرحله‌ی اول: split با مقدار پیش‌فرض
    splitter = build_splitter(chunk_size, overlap)
    split_docs = splitter.split_documents(docs)

    # اگر خالی شد، برگردان
    if not split_docs:
        return []

    # اگر بیش از هدف بود، سعی می‌کنیم chunk_size را بزرگ کنیم تا تعداد چانک کم شود
    if len(split_docs) > TARGET_MAX_CHUNKS:
        # نسبت بزرگ‌نمایی بر اساس نسبت فعلی به هدف
        scale = int((len(split_docs) / TARGET_MAX_CHUNKS) + 0.9999)  # ceil
        # حداکثر chunk_size را خیلی بزرگ نمی‌بریم، ولی اجازه می‌دهیم چند برابر شود
        new_chunk_size = min(chunk_size * max(2, scale), 10 * DEFAULT_CHUNK_SIZE)
        logger.warning(
            f"Chunk count {len(split_docs)} is high; increasing chunk_size from {chunk_size} to {new_chunk_size} to reduce chunks."
        )
        splitter = build_splitter(new_chunk_size, min(overlap, new_chunk_size // 5))
        split_docs = splitter.split_documents(docs)

    # اگر هنوز هم بیش از سقف سخت بود، خطا می‌دهیم
    if len(split_docs) > HARD_MAX_CHUNKS:
        raise ValueError(
            f"Too many chunks produced ({len(split_docs)}). "
            f"Please reduce input size or adjust split settings."
        )

    # فیلتر چانک‌های خالی/سفید
    split_docs = [d for d in split_docs if d.page_content and d.page_content.strip()]

    return split_docs


def make_embeddings_client() -> OpenAIEmbeddings:
    api_key = os.getenv("OPENAI_API_KEY")
    if not api_key:
        raise RuntimeError("OPENAI_API_KEY is not set in environment variables.")

    # توجه: پارامترهای ناپایدار را حذف کردیم (مثل chunk_size در Embeddings)
    # LangChain نسخه‌های مختلف پارامترهای متفاوتی دارند؛ این تنظیمات پایدارترند.
    return OpenAIEmbeddings(
        model="text-embedding-3-small",
        api_key=api_key,
        timeout=60,
        max_retries=5,
    )


# ==============================
# Celery Tasks
# ==============================
@celery_app.task(name="tasks.process_excel_file")
def process_excel_file(assistant_id: int, excel_path: str, user_id: str):
    """
    1) خواندن اکسل + اعتبارسنجی
    2) ساخت Document ها و نرمال‌سازی
    3) Chunking پویا با کنترل سقف
    4) ساخت تسک‌های embedding و chord
    5) بروزرسانی وضعیت دستیار به «در حال پردازش»
    """
    try:
        if not os.path.isfile(excel_path):
            raise FileNotFoundError(f"Excel file not found: {excel_path}")

        df = pd.read_excel(excel_path)

        # اعتبارسنجی ستون‌ها
        cols = set(df.columns.astype(str))
        if QUESTION_COL not in cols or ANSWER_COL not in cols:
            raise ValueError(
                f"Excel must include '{QUESTION_COL}' and '{ANSWER_COL}' columns. Found: {list(cols)}"
            )

        # ساخت Document ها
        docs: List[Document] = []
        truncated_rows = 0

        for idx, row in df.iterrows():
            q_raw = normalize_text(row.get(QUESTION_COL, ""))
            a_raw = normalize_text(row.get(ANSWER_COL, ""))

            # حذف ردیف‌های کاملاً خالی
            if not q_raw and not a_raw:
                continue

            q, q_tr = truncate_if_needed(q_raw)
            a, a_tr = truncate_if_needed(a_raw)

            if q_tr or a_tr:
                truncated_rows += 1

            content = f"سوال: {q}\nپاسخ: {a}"
            docs.append(
                Document(
                    page_content=content,
                    metadata={"row_index": int(idx)}
                )
            )

        if not docs:
            raise ValueError("No valid rows found in Excel (both columns empty).")

        logger.info(f"Valid documents: {len(docs)} | truncated_rows: {truncated_rows}")

        # Chunking پویا
        split_docs = dynamic_split_documents(docs)
        logger.info(f"Total chunks created: {len(split_docs)}")

        # مسیر ذخیره
        save_path = os.path.join(get_user_path(user_id), "vectorstores", str(assistant_id))
        chunks_dir = os.path.join(save_path, "chunks")
        ensure_dir(chunks_dir)

        # اگر هیچ چانکی نبود، خطا
        if not split_docs:
            raise ValueError("No chunks produced after splitting. Check input data.")

        # تسک‌ها
        tasks = []
        for chunk in split_docs:
            chunk_id = str(uuid.uuid4())
            chunk_save_path = os.path.join(chunks_dir, f"chunk_{chunk_id}")
            # فقط چانک‌های غیرخالی را صف می‌کنیم
            if chunk.page_content and chunk.page_content.strip():
                tasks.append(embed_chunk.s(chunk.page_content, chunk_save_path))

        logger.info(f"Total tasks queued: {len(tasks)}")

        if not tasks:
            raise ValueError("No non-empty chunks to embed.")

        # Callback ادغام
        callback = merge_chunks.s(save_path, chunks_dir, assistant_id, user_id, excel_path)
        chord(tasks)(callback)

        # وضعیت دستیار → در حال پردازش
        try:
            with SessionLocal() as db:
                assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
                if assistant:
                    assistant.status = False  # در حال پردازش
                    assistant.faiss_url = None
                    assistant.pkl_url = None
                    db.commit()
        except Exception as db_err:
            logger.warning(f"DB update (processing state) failed: {db_err}")

    except Exception as e:
        logger.error(f"[process_excel_file] Error for assistant {assistant_id}: {e}")
        # به‌روزرسانی وضعیت خطا
        try:
            with SessionLocal() as db:
                assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
                if assistant:
                    assistant.status = False  # یا می‌توانید فیلد مجزای error_status داشته باشید
                    assistant.faiss_url = None
                    assistant.pkl_url = None
                    db.commit()
        except Exception as db_err:
            logger.warning(f"DB update after error failed: {db_err}")


@celery_app.task(name="tasks.embed_chunk")
def embed_chunk(text_chunk: str, save_path: str):
    """
    ایجاد یک FAISS محلی از یک چانک متن.
    نکته: چانک‌های خالی را قبلاً حذف کرده‌ایم.
    """
    try:
        content = (text_chunk or "").strip()
        if not content:
            logger.warning(f"[embed_chunk] Empty content received for path {save_path}. Skipping.")
            return False

        embed = make_embeddings_client()

        # ساخت و ذخیره‌ی وکتور‌استور برای این چانک
        vectorstore = FAISS.from_documents([Document(page_content=content)], embed)
        ensure_dir(save_path)
        vectorstore.save_local(save_path)

        logger.info(f"[embed_chunk] Chunk saved to {save_path}")
        return True

    except Exception as e:
        logger.error(f"[embed_chunk] Error embedding to {save_path}: {e}")
        return False


@celery_app.task(name="tasks.merge_chunks")
def merge_chunks(results, save_path: str, chunks_dir: str, assistant_id: int, user_id: str, excel_path: str):
    """
    1) بررسی موفقیت همه‌ی تسک‌ها
    2) بارگذاری FAISS های جزئی
    3) ادغام و ذخیره‌ی نهایی
    4) پاکسازی پوشه‌ی چانک‌ها
    5) بروزرسانی DB و حذف فایل اکسل
    """
    try:
        # 1) بررسی خروجی تسک‌ها
        if not results or not all(bool(r) for r in results):
            logger.error("[merge_chunks] Some chunks failed. Aborting merge.")
            _update_assistant_status_on_error(assistant_id)
            return

        embed = make_embeddings_client()

        # 2) جمع‌آوری مسیرهای معتبر چانک
        if not os.path.isdir(chunks_dir):
            raise FileNotFoundError(f"Chunks directory not found: {chunks_dir}")

        chunk_paths = []
        for d in os.listdir(chunks_dir):
            p = os.path.join(chunks_dir, d)
            if os.path.isdir(p) and os.path.isfile(os.path.join(p, "index.faiss")):
                chunk_paths.append(p)

        if not chunk_paths:
            raise RuntimeError("No valid chunk indexes found to merge.")

        # 3) بارگذاری و ادغام
        vectorstores = []
        for path in chunk_paths:
            try:
                vs = FAISS.load_local(path, embed, allow_dangerous_deserialization=True)
                vectorstores.append(vs)
            except Exception as e:
                logger.warning(f"[merge_chunks] Failed to load chunk {path}: {e}")

        if not vectorstores:
            raise RuntimeError("No vectorstores could be loaded for merging.")

        if len(vectorstores) < len(chunk_paths):
            logger.warning(
                f"[merge_chunks] Loaded {len(vectorstores)} / {len(chunk_paths)} vectorstores."
            )

        final_store = vectorstores[0]
        for vs in vectorstores[1:]:
            final_store.merge_from(vs)

        # مسیر نهایی را ایجاد و ذخیره کنیم
        ensure_dir(save_path)
        final_store.save_local(save_path)
        logger.info(f"[merge_chunks] Final vectorstore saved at {save_path}")

        # 4) پاکسازی پوشه‌ی چانک‌ها
        _safe_rmtree(chunks_dir, label="chunks_dir")

        # 5) بروزرسانی DB و حذف اکسل
        try:
            with SessionLocal() as db:
                assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
                if assistant:
                    assistant.status = True  # آماده
                    assistant.faiss_url = os.path.join(save_path, "index.faiss")
                    assistant.pkl_url = os.path.join(save_path, "index.pkl")
                    db.commit()
                    logger.info(f"[merge_chunks] Assistant {assistant_id} marked as ready.")
        except Exception as db_err:
            logger.warning(f"[merge_chunks] DB update (ready state) failed: {db_err}")

        # حذف فایل اکسل ورودی (اختیاری)
        if os.path.isfile(excel_path):
            try:
                os.remove(excel_path)
                logger.info(f"[merge_chunks] Excel file removed: {excel_path}")
            except Exception as e:
                logger.warning(f"[merge_chunks] Failed to remove excel file: {e}")

    except Exception as e:
        logger.error(f"[merge_chunks] Error for assistant {assistant_id}: {e}")
        _update_assistant_status_on_error(assistant_id)


# ==============================
# توابع داخلی کمکی (DB/FS)
# ==============================
def _update_assistant_status_on_error(assistant_id: int) -> None:
    try:
        with SessionLocal() as db:
            assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
            if assistant:
                assistant.status = False
                assistant.faiss_url = None
                assistant.pkl_url = None
                db.commit()
    except Exception as db_err:
        logger.warning(f"[status_on_error] DB update failed: {db_err}")


def _safe_rmtree(path: str, label: str = "") -> None:
    if not path or not os.path.exists(path):
        return
    try:
        shutil.rmtree(path)
        logger.info(f"[cleanup] Removed {label}: {path}")
    except Exception as e:
        logger.warning(f"[cleanup] Failed to remove {label} at {path}: {e}")
