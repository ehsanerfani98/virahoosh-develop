# models/user.py
from sqlalchemy import Column, String
from sqlalchemy.orm import relationship
from database.session import Base
import uuid

class User(Base):
    __tablename__ = "users"
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), unique=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=True)
    phone = Column(String(20), unique=True, index=True, nullable=True)
    password = Column(String(255), nullable=True)
    # همه relationshipها را به صورت رشته‌ای تغییر دهید
    refresh_tokens = relationship("RefreshTokenDB", back_populates="user", cascade="all, delete-orphan")
    tokens = relationship("TokenDB", back_populates="user", cascade="all, delete-orphan")
    roles = relationship("Role", secondary="user_roles", back_populates="users")
    subscriptions = relationship("UserSubscription", back_populates="user", cascade="all, delete-orphan")
    tokens_usage = relationship("UserToken", back_populates="user", cascade="all, delete-orphan")
    payments = relationship("Payment", back_populates="user")
    assistants = relationship("Assistant", back_populates="user", cascade="all, delete-orphan")
    archives = relationship("AiArchive", back_populates="user")
    file_uploads = relationship("FileUpload", back_populates="user")