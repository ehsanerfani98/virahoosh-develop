# crud/permission.py
from sqlalchemy.orm import Session
from typing import Optional, List
from models.permission import Permission

def create_permission(db: Session, name: str, title: Optional[str] = None) -> Permission:
    permission = Permission(name=name, title=title)
    db.add(permission)
    db.commit()
    db.refresh(permission)
    return permission

def get_permission_by_name(db: Session, name: str) -> Optional[Permission]:
    return db.query(Permission).filter_by(name=name).first()

def get_permission_by_id(db: Session, permission_id: int) -> Optional[Permission]:
    return db.query(Permission).filter_by(id=permission_id).first()

def get_all_permissions(db: Session) -> List[Permission]:
    return db.query(Permission).all()
