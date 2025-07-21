# models/aiinput.py
from sqlalchemy import Column, Integer, String, Boolean, ForeignKey, Text
from sqlalchemy.orm import relationship
from database.session import Base

class AiInput(Base):
    __tablename__ = "ai_inputs"

    id = Column(Integer, primary_key=True, index=True)
    ai_model_id = Column(Integer, ForeignKey("ai_models.id", ondelete="CASCADE"), nullable=False)
    title = Column(String(255), nullable=False)        
    name = Column(String(100), nullable=False)         
    input_type = Column(String(50), nullable=False)    
    options = Column(Text, nullable=True)
    
    ai_model = relationship("AiModel", back_populates="inputs")
