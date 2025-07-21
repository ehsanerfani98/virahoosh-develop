# models/user_role.py
from database.session import Base
from sqlalchemy import Table, Column, ForeignKey, Integer, String

user_roles_table = Table(
    "user_roles",
    Base.metadata,
    Column("user_id", String(36), ForeignKey("users.id"), primary_key=True),
    Column("role_id", Integer, ForeignKey("roles.id"), primary_key=True)
)
