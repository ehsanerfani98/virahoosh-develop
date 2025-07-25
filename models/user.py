# models/user.py
from sqlalchemy import Column, Integer, String
from database.session import Base
from sqlalchemy.orm import relationship
from models.user_role import user_roles_table
import uuid

class User(Base):
    __tablename__ = "users"
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), unique=True, index=True)
    email = Column(String(255), unique=True, index=True, nullable=True)
    phone = Column(String(20), unique=True, index=True, nullable=True)
    password = Column(String(255), nullable=True)

    refresh_tokens = relationship("RefreshTokenDB", back_populates="user", cascade="all, delete-orphan" )
    tokens = relationship("TokenDB", back_populates="user", cascade="all, delete-orphan" )
    roles = relationship("Role", secondary=user_roles_table, back_populates="users")
