import os
import hashlib
from fastapi import UploadFile, HTTPException
from sqlalchemy.orm import Session
from datetime import datetime
from core.config import TEHRAN_TZ
from models.file_upload import FileUpload
import time

# حداکثر فضای ذخیره‌سازی (بر حسب بایت)
USER_STORAGE_LIMIT = 50 * 1024 * 1024  # 100MB

BASE_UPLOAD_DIR = "static/uploads"


def get_user_storage_path(user_id: str) -> str:
    """برگرداندن مسیر پوشه مخصوص کاربر"""
    return os.path.join(BASE_UPLOAD_DIR, f"user_{user_id}")


def get_folder_size(folder_path: str) -> int:
    """بررسی حجم فعلی پوشه"""
    total_size = 0
    if not os.path.exists(folder_path):
        return 0
    for dirpath, _, filenames in os.walk(folder_path):
        for f in filenames:
            fp = os.path.join(dirpath, f)
            if os.path.isfile(fp):
                total_size += os.path.getsize(fp)
    return total_size


def detect_file_type(content_type: str) -> str:
    """تشخیص نوع فایل بر اساس content-type"""
    if content_type.startswith("image/"):
        return "image"
    elif content_type.startswith("audio/"):
        return "audio"
    elif content_type.startswith("video/"):
        return "video"
    elif content_type in [
        "application/pdf",
        "application/msword",
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
        "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
        "application/vnd.ms-excel",
        "text/csv",
        "text/plain"
    ]:
        return "document"
    else:
        return "other"

async def upload_file(
    file: UploadFile,
    user_id: str,
    db: Session,
    save_to_db: bool = True,
    content_type: str = None,
    change_file_name: bool = True,
) -> str:
    user_folder = get_user_storage_path(user_id)
    os.makedirs(user_folder, exist_ok=True)
    os.chmod(user_folder, 0o775)
    
    contents = await file.read()
    file_size = len(contents)

    check_user_storage_limit(user_id, file_size)

    # تغییر نام فایل اگر change_file_name=True
    if change_file_name:
        ext = os.path.splitext(file.filename)[1]  # شامل نقطه (مثلاً ".xlsx")
        unique_str = f"{file.filename}_{time.time()}"
        hashed_name = hashlib.sha256(unique_str.encode()).hexdigest()[:16]
        new_filename = f"{hashed_name}{ext}"
    else:
        new_filename = file.filename

    file_path = os.path.join(user_folder, new_filename)
    with open(file_path, "wb") as f:
        f.write(contents)

    await file.seek(0)

    # تشخیص نوع محتوا
    detected_type = content_type or file.content_type or detect_file_type(new_filename)

    if save_to_db:
        file_record = FileUpload(
            user_id=user_id,
            filename=new_filename,
            filepath=file_path,
            size=file_size,
            content_type=detected_type,
            uploaded_at=datetime.now(TEHRAN_TZ)
        )
        db.add(file_record)
        db.commit()  # یا db.flush() بسته به نیاز

    return file_path

def upload_file_from_bytes(
    user_id: str,
    filename: str,
    file_bytes: bytes,
    db: Session,
    save_to_db: bool = True,
    content_type: str = None,
    change_file_name: bool = True,
) -> str:
    user_folder = get_user_storage_path(user_id)
    os.makedirs(user_folder, exist_ok=True)
    os.chmod(user_folder, 0o775)

    check_user_storage_limit(user_id, len(file_bytes))

    # تغییر نام فایل اگر change_file_name=True
    if change_file_name:
        ext = os.path.splitext(filename)[1]  # شامل نقطه مثل ".xlsx"
        unique_str = f"{filename}_{time.time()}"
        hashed_name = hashlib.sha256(unique_str.encode()).hexdigest()[:16]
        new_filename = f"{hashed_name}{ext}"
    else:
        new_filename = filename

    file_path = os.path.join(user_folder, new_filename)
    with open(file_path, "wb") as f:
        f.write(file_bytes)

    # تشخیص نوع محتوا
    detected_type = content_type or detect_file_type(new_filename)

    if save_to_db:
        file_record = FileUpload(
            user_id=user_id,
            filename=new_filename,
            filepath=file_path,
            size=len(file_bytes),
            content_type=detected_type,
            uploaded_at=datetime.now(TEHRAN_TZ)
        )
        db.add(file_record)
        db.commit()  # یا db.flush() بسته به استراتژی کاری

    return file_path



def check_user_storage_limit(user_id: str, additional_size: int):
    user_folder = get_user_storage_path(user_id)
    current_usage = get_folder_size(user_folder)
    if current_usage + additional_size > USER_STORAGE_LIMIT:
        raise HTTPException(
            status_code=403, detail="فضای ذخیره‌سازی شما کافی نیست.")
