# models/permission.py
from sqlalchemy import Column, Integer, String
from sqlalchemy.orm import relationship
from database.session import Base
from models.role import role_permissions

class Permission(Base):
    __tablename__ = "permissions"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(256), unique=True, index=True)
    title = Column(String(256), unique=True, index=True)
    roles = relationship(
        "Role",
        secondary=role_permissions,
        back_populates="permissions"
    )