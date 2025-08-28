# models/ai.py
from sqlalchemy import Column, Integer, String, Enum, Text
from sqlalchemy.orm import relationship
from database.session import Base
import enum

class AiModelType(enum.Enum):
    image = "image"
    text = "text"
    text_image = "text_image"
    video = "video"
    audio = "audio"
    vision = "vision"
    speech_audio = "speech_audio"

class AiModel(Base):
    __tablename__ = "ai_models"
    id = Column(Integer, primary_key=True, index=True)
    icon = Column(String(255), nullable=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    provider = Column(String(255), nullable=False)
    model = Column(String(255), nullable=False)
    prompt = Column(Text, nullable=True)
    system_prompt = Column(Text, nullable=True)
    max_tokens = Column(Integer, nullable=True, default=500)
    type = Column(Enum(AiModelType), nullable=False, default="text")
    inputs = relationship(
        "AiInput", back_populates="ai_model", cascade="all, delete-orphan")
    archives = relationship("AiArchive", back_populates="ai_model")