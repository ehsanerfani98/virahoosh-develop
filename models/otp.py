# models/otp.py
from sqlalchemy import Column, Integer, String, DateTime, Boolean
from database.session import Base
from core.config import TEHRAN_TZ
from datetime import datetime

class OtpDB(Base):
    __tablename__ = "otps"
    id = Column(Integer, primary_key=True, index=True)
    phone = Column(String(20), index=True, nullable=False)
    otp_code = Column(String(6), nullable=False)
    expire_at = Column(DateTime(timezone=True), nullable=False)
    created_at = Column(DateTime, default=lambda: datetime.now(TEHRAN_TZ))
    is_used = Column(Boolean, default=False)
