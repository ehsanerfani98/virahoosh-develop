# models/file_upload.py
from models.user import User
from sqlalchemy import Column, Integer, ForeignKey, String, DateTime
from sqlalchemy.orm import relationship
from datetime import datetime
from database.session import Base
from core.config import TEHRAN_TZ

class FileUpload(Base):
    __tablename__ = "file_uploads"

    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    filename = Column(String(255), nullable=False)
    filepath = Column(String(512), nullable=False)
    content_type = Column(String(100), nullable=True)
    size = Column(Integer, nullable=False)
    uploaded_at = Column(DateTime, default=lambda: datetime.now(TEHRAN_TZ))

    user = relationship(User)
