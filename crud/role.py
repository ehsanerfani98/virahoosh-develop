# crud/role.py
from sqlalchemy.orm import Session
from typing import Optional, List
from models.role import Role

def get_role_by_name(db: Session, name: str) -> Optional[Role]:
    return db.query(Role).filter_by(name=name).first()

def create_role(db: Session, name: str, title: Optional[str]) -> Role:
    new_role = Role(name=name, title=title)
    db.add(new_role)
    db.commit()
    db.refresh(new_role)
    return new_role

def get_all_roles(db: Session) -> List[Role]:
    return db.query(Role).all()
