# # services/tasks.py

# import os
# import pandas as pd
# from langchain_community.vectorstores import FAISS
# from langchain_community.embeddings import OpenAIEmbeddings
# from langchain.schema import Document
# from database.session import SessionLocal
# from models.assistant import Assistant
# from celery_app import celery_app

# def get_user_path(user_id: str) -> str:
#     return os.path.join("static/uploads", f"user_{user_id}")

# def normalize_text(text: str) -> str:
#     mapping = str.maketrans("۰۱۲۳۴۵۶۷۸۹", "0123456789")
#     return text.translate(mapping)

# @celery_app.task(name="tasks.process_excel_file")
# def process_excel_file(assistant_id: int, excel_path: str, user_id : str):
#     db = SessionLocal()

#     try:
#         df = pd.read_excel(excel_path)
#         docs = []
#         for _, row in df.iterrows():
#             q = normalize_text(str(row.get("سوال", "")))
#             a = normalize_text(str(row.get("پاسخ", "")))
#             docs.append(Document(page_content=f"سوال: {q}\nپاسخ: {a}"))

#         embed = OpenAIEmbeddings(model="text-embedding-3-small")
        
#         save_path = f"{get_user_path(user_id)}/vectorstores/{assistant_id}"
#         os.makedirs(save_path, exist_ok=True)

#         vectorstore = FAISS.from_documents(docs, embed)
#         vectorstore.save_local(save_path)

#         # به‌روزرسانی رکورد در پایگاه داده
#         assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
#         assistant.status = True
#         assistant.faiss_url = f"{save_path}/index.faiss"
#         assistant.pkl_url = f"{save_path}/index.pkl"
#         db.commit()

#          # حذف فایل فیزیکی
#         if assistant.excel_url and os.path.isfile(assistant.excel_url):
#             try:
#                 os.remove(assistant.excel_url)
#             except Exception as e:
#                 print(f"خطا در حذف فایل: {e}")

#     except Exception as e:
#         print(f"Error processing assistant {assistant_id}: {str(e)}")
#     finally:
#         db.close()


import os
import pandas as pd
import logging
import shutil
from langchain_community.vectorstores import FAISS
from langchain_openai import OpenAIEmbeddings
from langchain.schema import Document
from langchain.text_splitter import RecursiveCharacterTextSplitter
from database.session import SessionLocal
from models.assistant import Assistant
from celery_app import celery_app
from celery import chord
import uuid

# تنظیم logger
logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


def get_user_path(user_id: str) -> str:
    return os.path.join("static/uploads", f"user_{user_id}")


def normalize_text(text: str) -> str:
    mapping = str.maketrans("۰۱۲۳۴۵۶۷۸۹", "0123456789")
    return text.translate(mapping)


@celery_app.task(name="tasks.process_excel_file")
def process_excel_file(assistant_id: int, excel_path: str, user_id: str):
    try:
        df = pd.read_excel(excel_path)
        docs = []
        for _, row in df.iterrows():
            q = normalize_text(str(row.get("سوال", "")))
            a = normalize_text(str(row.get("پاسخ", "")))
            content = f"سوال: {q}\nپاسخ: {a}"
            docs.append(Document(page_content=content))

        text_splitter = RecursiveCharacterTextSplitter(chunk_size=1000, chunk_overlap=200)
        split_docs = text_splitter.split_documents(docs)

        save_path = f"{get_user_path(user_id)}/vectorstores/{assistant_id}"
        chunks_dir = os.path.join(save_path, "chunks")
        os.makedirs(chunks_dir, exist_ok=True)
        os.chmod(chunks_dir, 0o755)

        tasks = []
        for chunk in split_docs:
            chunk_id = str(uuid.uuid4())
            chunk_save_path = os.path.join(chunks_dir, f"chunk_{chunk_id}")
            tasks.append(embed_chunk.s(chunk.page_content, chunk_save_path))

        callback = merge_chunks.s(save_path, chunks_dir, assistant_id, user_id, excel_path)
        chord(tasks)(callback)

        # به‌روزرسانی وضعیت دستیار در DB به حالت در حال پردازش
        with SessionLocal() as db:
            assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
            if assistant:
                assistant.status = False
                assistant.faiss_url = None
                assistant.pkl_url = None
                db.commit()

    except Exception as e:
        logger.error(f"Error processing assistant {assistant_id}: {str(e)}")


@celery_app.task(name="tasks.embed_chunk")
def embed_chunk(text_chunk: str, save_path: str):
    try:
        embed = OpenAIEmbeddings(
            model="text-embedding-3-small",
            api_key=os.getenv("OPENAI_API_KEY"),
            timeout=60,
            chunk_size=300,  # افزایش chunk_size به 300
            max_retries=5
        )

        vectorstore = FAISS.from_documents([Document(page_content=text_chunk)], embed)
        os.makedirs(save_path, exist_ok=True)
        os.chmod(save_path, 0o755)
        vectorstore.save_local(save_path)
        return True
    
    except Exception as e:
        logger.error(f"Error embedding chunk to {save_path}: {str(e)}")
        return False

@celery_app.task(name="tasks.merge_chunks")
def merge_chunks(save_path: str, chunks_dir: str, assistant_id: int, user_id: str, excel_path: str):
    try:
        embed = OpenAIEmbeddings(
            model="text-embedding-3-small",
            api_key=os.getenv("OPENAI_API_KEY"),
        )

        chunk_paths = [
            os.path.join(chunks_dir, d)
            for d in os.listdir(chunks_dir)
            if os.path.isdir(os.path.join(chunks_dir, d))
        ]

        if not chunk_paths:
            raise Exception("هیچ chunk ای برای ادغام یافت نشد.")

        vectorstores = []
        for path in chunk_paths:
            try:
                vs = FAISS.load_local(path, embed)
                vectorstores.append(vs)
            except Exception as e:
                logger.warning(f"خطا در بارگذاری chunk {path}: {str(e)}")

        if len(vectorstores) < len(chunk_paths):
            logger.warning(f"تعداد vectorstoreهای بارگذاری شده ({len(vectorstores)}) کمتر از تعداد chunkها ({len(chunk_paths)}) است.")

        final_store = vectorstores[0]
        for vs in vectorstores[1:]:
            final_store.merge_from(vs)

        final_store.save_local(save_path)

        # پاکسازی فایل‌های موقت chunk
        try:
            shutil.rmtree(chunks_dir)
        except Exception as e:
            logger.warning(f"خطا در حذف پوشه chunk ها: {str(e)}")

        # به‌روزرسانی وضعیت و مسیر فایل در دیتابیس و حذف فایل اکسل
        with SessionLocal() as db:
            assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
            if assistant:
                assistant.status = True
                assistant.faiss_url = os.path.join(save_path, "index.faiss")
                assistant.pkl_url = os.path.join(save_path, "index.pkl")
                db.commit()

        if os.path.isfile(excel_path):
            try:
                os.remove(excel_path)
            except Exception as e:
                logger.warning(f"خطا در حذف فایل اکسل: {e}")

    except Exception as e:
        logger.error(f"Error merging chunks for assistant {assistant_id}: {str(e)}")
