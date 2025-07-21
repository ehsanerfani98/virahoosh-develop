# controllers/role_controller.py
from fastapi import HTTPException
from sqlalchemy.orm import Session
from typing import List, Optional

from crud import role as role_crud
from crud import permission as permission_crud
from crud import user_role as user_role_crud
from crud import role_permission as role_permission_crud
from models.role import Role
from models.permission import Permission


def create_role(name: str, title: Optional[str], db: Session) -> Role:
    existing = role_crud.get_role_by_name(db, name)
    if existing:
        raise HTTPException(status_code=400, detail="نقش قبلا وجود دارد")
    return role_crud.create_role(db, name, title)


def create_permission(name: str, title: Optional[str], db: Session) -> Permission:
    existing = permission_crud.get_permission_by_name(db, name)
    if existing:
        raise HTTPException(status_code=400, detail="مجوز قبلا وجود دارد")
    return permission_crud.create_permission(db, name, title)


def assign_role_to_user(user_id: str, role_id: int, db: Session) -> dict:
    # می‌توان اینجا بررسی وجود کاربر و نقش را اضافه کرد (اختیاری)
    result = user_role_crud.assign_role_to_user(db, user_id, role_id)
    return {"message": "نقش با موفقیت به کاربر اختصاص داده شد"}


def add_permission_to_role(role_id: int, permission_id: int, db: Session) -> dict:
    # بررسی وجود نقش و مجوز می‌تواند اضافه شود
    result = role_permission_crud.add_permission_to_role(
        db, role_id, permission_id)
    return {"message": "مجوز با موفقیت به نقش اختصاص داده شد"}


def get_roles_for_user(user_id: str, db: Session) -> List[Role]:
    return user_role_crud.get_roles_of_user(db, user_id)


def get_permissions_for_role(role_id: int, db: Session) -> List[Permission]:
    return role_permission_crud.get_permissions_of_role(db, role_id)
