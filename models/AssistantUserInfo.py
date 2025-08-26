import uuid
from sqlalchemy import Column, Integer, String, ForeignKey
from sqlalchemy.dialects.postgresql import UUID
from sqlalchemy.orm import relationship
from database.session import Base

class AssistantUserInfo(Base):
    __tablename__ = "assistant_user_infos"

    id = Column(Integer, primary_key=True, index=True)
    assistant_id = Column(Integer, ForeignKey("assistants.id"), nullable=False)
    fullname = Column(String(255), nullable=False)
    mobile = Column(String(20), nullable=False)
    email = Column(String(255), nullable=False)
    slug = Column(String(36), unique=True, nullable=False, default=lambda: str(uuid.uuid4()))

    assistant = relationship("Assistant", backref="user_infos")
