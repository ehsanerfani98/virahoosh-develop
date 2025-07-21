# models/role.py
from sqlalchemy import Column, Integer, String, Table, ForeignKey
from sqlalchemy.orm import relationship
from database.session import Base
from models.user_role import user_roles_table

role_permissions = Table(
    "role_permissions",
    Base.metadata,
    Column("role_id", Integer, ForeignKey("roles.id")),
    Column("permission_id", Integer, ForeignKey("permissions.id"))
)

class Role(Base):
    __tablename__ = "roles"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(256), unique=True, index=True)
    title = Column(String(256), unique=True, index=True)

    permissions = relationship(
        "Permission",
        secondary=role_permissions,
        back_populates="roles"
    )

    users = relationship(
        "User",
        secondary=user_roles_table,
        back_populates="roles"
    )
