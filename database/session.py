# database/session.py
from sqlalchemy import create_engine
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from core.config import DATABASE_URL

engine = create_engine(
    DATABASE_URL,
    pool_size=10,          # افزایش ظرفیت پیش‌فرض
    max_overflow=20,       # حداکثر اتصال‌های اضافی
    pool_recycle=1800,     # اتصال‌ها پس از 1 ساعت تجدید شوند
    pool_timeout=30,       # زمان انتظار برای اتصال
    echo=False             # برای دیباگ می‌توانید True کنید
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()  # حتماً اتصال بسته شود