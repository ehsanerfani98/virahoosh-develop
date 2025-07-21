# crud/user_role.py
from sqlalchemy.orm import Session
from sqlalchemy import select, insert, delete
from typing import List, Dict, Any
from models.user_role import user_roles_table


def assign_role_to_user(db: Session, user_id: str, role_id: int) -> Dict[str, str]:
    stmt = select(user_roles_table).where(
        user_roles_table.c.user_id == user_id,
        user_roles_table.c.role_id == role_id
    )
    result = db.execute(stmt).first()
    if result:
        return {"message": "قبلاً نقش اختصاص داده شده است"}

    stmt = insert(user_roles_table).values(user_id=user_id, role_id=role_id)
    db.execute(stmt)
    db.commit()
    return {"message": "نقش با موفقیت به کاربر اختصاص داده شد"}


def get_roles_of_user(db: Session, user_id: str) -> List[Any]:
    stmt = select(user_roles_table).where(
        user_roles_table.c.user_id == user_id)
    result = db.execute(stmt).fetchall()
    return result


def remove_role_from_user(db: Session, user_id: str, role_id: int) -> bool:
    stmt = delete(user_roles_table).where(
        user_roles_table.c.user_id == user_id,
        user_roles_table.c.role_id == role_id
    )
    result = db.execute(stmt)
    db.commit()
    return result.rowcount > 0
