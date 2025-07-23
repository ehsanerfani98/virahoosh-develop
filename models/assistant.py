import uuid
from sqlalchemy import Column, Integer, String, Text, Boolean
from sqlalchemy.sql import func
from database.session import Base

def generate_uuid():
    return str(uuid.uuid4())

class Assistant(Base):
    __tablename__ = "assistants"

    id = Column(Integer, primary_key=True, index=True)
    title = Column(String(255), nullable=False)
    description = Column(Text, nullable=True)
    faiss_url = Column(String(500), nullable=True)
    pkl_url = Column(String(500), nullable=True)
    excel_url = Column(String(500), nullable=True)
    status = Column(Boolean, default=False)
    slug = Column(String(36), unique=True, nullable=False, default=generate_uuid)
