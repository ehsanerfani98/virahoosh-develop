# utils/token.py
from datetime import datetime, timedelta
import uuid
import hashlib
from jose import jwt
from core.config import SECRET_KEY, ALGORITHM
from fastapi import Request, HTTPException
from core.config import TOKEN_PREFIX
from models.user import User
from core.config import TEHRAN_TZ
from jose import jwt, JWTError
from sqlalchemy.orm import Session
from models.token import TokenDB
from models.refreshtoken import RefreshTokenDB
from jose import jwt, JWTError, ExpiredSignatureError

def hash_token(token: str) -> str:
    return hashlib.sha256(token.encode()).hexdigest()

def create_token(user: User, login_type: str = "email") -> str:
    now_utc = datetime.now(TEHRAN_TZ)
    expire = now_utc + timedelta(minutes=15)
    
    payload = {
        "sub": str(user.id),
        "login_type": login_type,
        "email": user.email if login_type == "email" else None,
        "phone": user.phone if login_type == "phone" else None,
        "iat": int(now_utc.timestamp()),
        "exp": int(expire.timestamp()),
        "jti": str(uuid.uuid4()),
        "type": "access"
    }

    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token

def create_refresh_token(user: User, login_type: str = "email") -> str:
    now_utc = datetime.now(TEHRAN_TZ)
    expire = now_utc + timedelta(days=7)

    payload = {
        "sub": str(user.id),
        "login_type": login_type,
        "email": user.email if login_type == "email" else None,
        "phone": user.phone if login_type == "phone" else None,
        "iat": int(now_utc.timestamp()),
        "exp": int(expire.timestamp()),
        "jti": str(uuid.uuid4()),
        "type": "refresh"
    }

    token = jwt.encode(payload, SECRET_KEY, algorithm=ALGORITHM)
    return token

def create_tokens(user: User, login_type: str = "email") -> dict:
    access_token = create_token(user, login_type)
    refresh_token = create_refresh_token(user, login_type)
    return {
        "access_token": access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }

def get_token_from_header(request: Request) -> str:
    auth_header = request.headers.get("Authorization")
    if not auth_header or not auth_header.startswith(TOKEN_PREFIX):
        raise HTTPException(status_code=403, detail="توکن معتبر ارائه نشده است")
    return auth_header[len(TOKEN_PREFIX):]

def get_token(request: Request) -> str:
    # بررسی Authorization header
    auth_header = request.headers.get("Authorization")
    if auth_header and auth_header.startswith(TOKEN_PREFIX):
        return auth_header[len(TOKEN_PREFIX):]

    # بررسی کوکی (مثلاً کوکی با نام access_token)
    token_cookie = request.cookies.get("access_token")
    if token_cookie:
        return token_cookie

    raise HTTPException(status_code=403, detail="توکن معتبر ارائه نشده است")

def verify_jwt_token(token: str, token_type: str = "access") -> dict:
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])

        if payload.get("type") != token_type:
            raise HTTPException(status_code=401, detail=f"توکن {token_type} معتبر نیست")

        return payload

    except JWTError:
        raise HTTPException(status_code=401, detail="توکن نامعتبر است")
     
def verify_token(token: str, db: Session, token_type: str = "access") -> dict:
    hashed = hash_token(token)

    if token_type == "access":
        db_token = db.query(TokenDB).filter_by(
            token=hashed, is_active=True).first()
    elif token_type == "refresh":
        db_token = db.query(RefreshTokenDB).filter_by(
            token=hashed, is_active=True).first()
    else:
        raise HTTPException(status_code=401, detail="نوع توکن نامعتبر است")

    if not db_token:
        raise HTTPException(
            status_code=401, detail="توکن نامعتبر یا باطل شده است")

    # بررسی انقضای توکن با تایم‌زون TEHRAN_TZ
    if hasattr(db_token, "expires_at") and db_token.expires_at:
        expires_at_aware = db_token.expires_at.replace(tzinfo=TEHRAN_TZ)
        if expires_at_aware < datetime.now(TEHRAN_TZ):
            if token_type == "refresh":
                _handle_expired_refresh_token(db, db_token)
            else:
                db.delete(db_token)
                db.commit()

            raise HTTPException(status_code=401, detail="توکن منقضی شده است")

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        if payload.get("type") != token_type:
            raise HTTPException(status_code=400, detail="نوع توکن نامعتبر است")
        return payload
    except ExpiredSignatureError:
        if token_type == "refresh":
            _handle_expired_refresh_token(db, db_token)
        else:
            db.delete(db_token)
            db.commit()
        raise HTTPException(status_code=401, detail="توکن منقضی شده است")
    except JWTError:
        raise HTTPException(status_code=401, detail="توکن معتبر نیست")

def _handle_expired_refresh_token(db: Session, db_token: RefreshTokenDB):
    # حذف توکن‌های دسترسی مربوط به توکن رفرش منقضی
    db.query(TokenDB).filter_by(user_id=db_token.user_id).delete()
    db.delete(db_token)
    db.commit()
