# models/ai_archive.py
from sqlalchemy import Column, Integer, ForeignKey, Text, DateTime, String
from sqlalchemy.orm import relationship
from datetime import datetime
from database.session import Base


class AiArchive(Base):
    __tablename__ = "ai_archives"

    id = Column(Integer, primary_key=True)
    ai_model_id = Column(Integer, ForeignKey("ai_models.id"))
    user_id = Column(String(36), ForeignKey("users.id"))
    title = Column(String(255), nullable=False)
    prompt = Column(Text)
    response = Column(Text)
    created_at = Column(DateTime, default=datetime.utcnow)
    type = Column(String(20), nullable=True)
    url = Column(String(512), nullable=True)
    
    
    ai_model = relationship("AiModel")
    user = relationship("User")