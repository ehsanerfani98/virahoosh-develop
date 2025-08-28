# models/assistant.py
import uuid
from sqlalchemy import Column, Integer, String, Text, Boolean, ForeignKey
from sqlalchemy.orm import relationship
from database.session import Base

class Assistant(Base):
    __tablename__ = "assistants"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    domain = Column(String(255), nullable=False)
    faiss_url = Column(String(500), nullable=True)
    pkl_url = Column(String(500), nullable=True)
    excel_url = Column(String(500), nullable=True)
    status = Column(Boolean, default=False)
    slug = Column(String(36), unique=True, nullable=False, default=lambda: str(uuid.uuid4()))
    
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)  
    
    user = relationship("User", back_populates="assistants")
    user_infos = relationship("AssistantUserInfo", back_populates="assistant", cascade="all, delete-orphan")