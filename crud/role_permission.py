# crud/role_permission.py
from sqlalchemy.orm import Session
from typing import Optional, List
from models.role import Role
from models.permission import Permission

def add_permission_to_role(db: Session, role_id: int, permission_id: int) -> Optional[Role]:
    role = db.query(Role).filter(Role.id == role_id).first()
    permission = db.query(Permission).filter(Permission.id == permission_id).first()
    if not role or not permission:
        return None  # نقش یا دسترسی وجود ندارد

    if permission in role.permissions:
        return role  # قبلا اضافه شده

    role.permissions.append(permission)
    db.commit()
    db.refresh(role)
    return role

def get_permissions_of_role(db: Session, role_id: int) -> List[Permission]:
    role = db.query(Role).filter(Role.id == role_id).first()
    if role:
        return role.permissions
    return []

def remove_permission_from_role(db: Session, role_id: int, permission_id: int) -> bool:
    role = db.query(Role).filter(Role.id == role_id).first()
    permission = db.query(Permission).filter(Permission.id == permission_id).first()
    if not role or not permission:
        return False

    if permission in role.permissions:
        role.permissions.remove(permission)
        db.commit()
        return True
    return False
