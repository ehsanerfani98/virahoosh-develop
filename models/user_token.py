# models/user_token.py
from sqlalchemy import Column, String, Integer, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from database.session import Base
from datetime import datetime
import uuid
from core.config import TEHRAN_TZ

class UserToken(Base):
    __tablename__ = "user_tokens"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), unique=True, index=True)
    
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False, index=True)
    user = relationship("User", back_populates="tokens_usage")

    tokens_used = Column(Integer, nullable=False)
    created_at = Column(DateTime, default=datetime.now(TEHRAN_TZ), nullable=False)

