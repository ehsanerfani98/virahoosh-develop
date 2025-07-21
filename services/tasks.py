# services/tasks.py

import os
import pandas as pd
from langchain_community.vectorstores import FAISS
from langchain_community.embeddings import OpenAIEmbeddings
from langchain.schema import Document
from database.session import SessionLocal
from models.assistant import Assistant
from celery_app import celery_app

def get_user_path(user_id: str) -> str:
    return os.path.join("static/uploads", f"user_{user_id}")

def normalize_text(text: str) -> str:
    mapping = str.maketrans("۰۱۲۳۴۵۶۷۸۹", "0123456789")
    return text.translate(mapping)

@celery_app.task(name="tasks.process_excel_file")
def process_excel_file(assistant_id: int, excel_path: str, user_id : str):
    db = SessionLocal()

    try:
        df = pd.read_excel(excel_path)
        docs = []
        for _, row in df.iterrows():
            q = normalize_text(str(row.get("سوال", "")))
            a = normalize_text(str(row.get("پاسخ", "")))
            docs.append(Document(page_content=f"سوال: {q}\nپاسخ: {a}"))

        embed = OpenAIEmbeddings(model="text-embedding-3-small")
        
        save_path = f"{get_user_path(user_id)}/vectorstores/{assistant_id}"
        os.makedirs(save_path, exist_ok=True)

        vectorstore = FAISS.from_documents(docs, embed)
        vectorstore.save_local(save_path)

        # به‌روزرسانی رکورد در پایگاه داده
        assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
        assistant.status = True
        assistant.faiss_url = f"{save_path}/index.faiss"
        assistant.pkl_url = f"{save_path}/index.pkl"
        db.commit()

         # حذف فایل فیزیکی
        if assistant.excel_url and os.path.isfile(assistant.excel_url):
            try:
                os.remove(assistant.excel_url)
            except Exception as e:
                print(f"خطا در حذف فایل: {e}")

    except Exception as e:
        print(f"Error processing assistant {assistant_id}: {str(e)}")
    finally:
        db.close()
