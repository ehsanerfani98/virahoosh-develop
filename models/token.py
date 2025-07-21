# models/token.py
from sqlalchemy import Column, Integer, String, DateTime, ForeignKey, Boolean
from database.session import Base
from datetime import datetime
from core.config import TEHRAN_TZ
from sqlalchemy.orm import relationship

class TokenDB(Base):
    __tablename__ = "tokens"
    id = Column(Integer, primary_key=True, index=True)
    token = Column(String(512), nullable=False, unique=True)
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)
    is_active = Column(Boolean, default=True)
    created_at = Column(DateTime, default=lambda: datetime.now(TEHRAN_TZ))

    user = relationship("User", back_populates="tokens")
