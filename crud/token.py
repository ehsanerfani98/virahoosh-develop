# crud/token.py
from sqlalchemy.orm import Session
from models.refreshtoken import RefreshTokenDB
from models.token import TokenDB
from datetime import datetime, timedelta
from core.config import TEHRAN_TZ
from typing import Optional
from utils.token import hash_token


def save_access_token(db: Session, token: str, user_id: str) -> TokenDB:
    db_token = TokenDB(
        token=token,
        user_id=user_id,
        is_active=True,
        created_at=datetime.now(TEHRAN_TZ),
    )
    db.add(db_token)
    try:
        db.commit()
        db.refresh(db_token)
    except Exception as e:
        db.rollback()
        raise e
    return db_token


def save_refresh_token(db: Session, token: str, user_id: str) -> RefreshTokenDB:
    db_token = RefreshTokenDB(
        token=token,
        user_id=user_id,
        is_active=True,
        created_at=datetime.now(TEHRAN_TZ),
        expires_at=datetime.now(TEHRAN_TZ) + timedelta(days=7)
    )
    db.add(db_token)
    try:
        db.commit()
        db.refresh(db_token)
    except Exception as e:
        db.rollback()
        raise e
    return db_token


def delete_old_access_tokens(db: Session, user_id: str, type="access") -> None:
    try:
        if (type == "access"):
            db.query(TokenDB).filter(TokenDB.user_id == user_id).delete()
        else:
            db.query(RefreshTokenDB).filter(
                RefreshTokenDB.user_id == user_id).delete()
        db.commit()

    except Exception:
        db.rollback()
        raise


def is_token_valid(db: Session, raw_token: str) -> bool:
    hashed = hash_token(raw_token)
    token = db.query(TokenDB).filter(TokenDB.token == hashed).first()
    return token is not None
