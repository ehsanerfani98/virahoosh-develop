# controllers/auth_controller.py
from fastapi import HTTPException, Depends
from jose import jwt, JWTError, ExpiredSignatureError
from passlib.hash import bcrypt
from sqlalchemy.orm import Session
from datetime import datetime
from core.config import SECRET_KEY, ALGORITHM, TEHRAN_TZ
from crud import user as user_crud, token as token_crud
from utils.token import create_tokens, hash_token, get_token
from schemas.user import UserCreate, UserLogin
from database.session import get_db
from models.user import User
from models.token import TokenDB
from models.refreshtoken import RefreshTokenDB
from fastapi.responses import JSONResponse

def signup_user(user_data: UserCreate, db: Session) -> JSONResponse:
    existing_user = user_crud.get_user_by_email(db, user_data.email)
    if existing_user:
        raise HTTPException(status_code=400, detail="این ایمیل قبلاً ثبت شده است")

    hashed_password = bcrypt.hash(user_data.password)
    user = user_crud.create_user(db, email=user_data.email, hashed_password=hashed_password)

    tokens = create_tokens(user, login_type="email")
    hashed_access_token = hash_token(tokens["access_token"])
    hashed_refresh_token = hash_token(tokens["refresh_token"])

    token_crud.save_access_token(db, hashed_access_token, user.id)
    token_crud.save_refresh_token(db, hashed_refresh_token, user.id)

    return _build_login_response(tokens)

def login_user(user_data: UserLogin, db: Session) -> JSONResponse:
    db_user = user_crud.get_user_by_email(db, user_data.email)
    if not db_user or not bcrypt.verify(user_data.password, db_user.password):
        raise HTTPException(status_code=401, detail="اطلاعات نادرست است")

    db.query(TokenDB).filter(TokenDB.user_id == db_user.id).delete()
    db.query(RefreshTokenDB).filter(RefreshTokenDB.user_id == db_user.id).delete()
    db.commit()

    tokens = create_tokens(db_user, login_type="email")
    hashed_access_token = hash_token(tokens["access_token"])
    hashed_refresh_token = hash_token(tokens["refresh_token"])

    token_crud.save_access_token(db, hashed_access_token, db_user.id)
    token_crud.save_refresh_token(db, hashed_refresh_token, db_user.id)

    return _build_login_response(tokens)

def logout_user(token: str, db: Session) -> JSONResponse:
    hashed_token = hash_token(token)

    access_token = db.query(TokenDB).filter_by(token=hashed_token, is_active=True).first()
    if access_token:
        access_token.is_active = False
        db.query(RefreshTokenDB).filter_by(user_id=access_token.user_id).update({"is_active": False})
        db.commit()
        token_crud.delete_old_access_tokens(db, access_token.user_id, type="access")
        token_crud.delete_old_access_tokens(db, access_token.user_id, type="refresh")
        response = JSONResponse(content={"message": "خروج با موفقیت انجام شد"})
        response.delete_cookie("access_token")
        response.delete_cookie("refresh_token")
        return response

    refresh_token = db.query(RefreshTokenDB).filter_by(token=hashed_token, is_active=True).first()
    if refresh_token:
        refresh_token.is_active = False
        db.query(TokenDB).filter_by(user_id=refresh_token.user_id).update({"is_active": False})
        db.commit()
        token_crud.delete_old_access_tokens(db, refresh_token.user_id, type="access")
        token_crud.delete_old_access_tokens(db, refresh_token.user_id, type="refresh")
        response = JSONResponse(content={"message": "خروج با موفقیت انجام شد"})
        response.delete_cookie("access_token")
        response.delete_cookie("refresh_token")
        return response

    raise HTTPException(status_code=404, detail="توکن پیدا نشد")

def get_current_user(
    token: str = Depends(get_token),
    db: Session = Depends(get_db)
) -> User:
    payload = verify_token(token, db, token_type="access")
    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=401, detail="شناسه کاربر در توکن موجود نیست")

    user = db.query(User).filter_by(id=user_id).first()
    if not user:
        raise HTTPException(status_code=401, detail="کاربر یافت نشد")

    return user

def _handle_expired_refresh_token(db: Session, db_token: RefreshTokenDB):
    # حذف توکن‌های دسترسی مربوط به توکن رفرش منقضی
    db.query(TokenDB).filter_by(user_id=db_token.user_id).delete()
    db.delete(db_token)
    db.commit()

def verify_token(token: str, db: Session, token_type: str = "access") -> dict:
    hashed = hash_token(token)

    if token_type == "access":
        db_token = db.query(TokenDB).filter_by(
            token=hashed, is_active=True).first()
    elif token_type == "refresh":
        db_token = db.query(RefreshTokenDB).filter_by(
            token=hashed, is_active=True).first()
    else:
        raise HTTPException(status_code=400, detail="نوع توکن نامعتبر است")

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
            raise HTTPException(status_code=401, detail="نوع توکن نامعتبر است")
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

def _build_login_response(tokens: dict) -> JSONResponse:
    response = JSONResponse(content={
        "message": "ورود موفق بود",
        "access_token": tokens["access_token"],
        "refresh_token": tokens["refresh_token"],
        "token_type": "bearer"
    })

    response.set_cookie(
        key="access_token",
        value=tokens["access_token"],
        httponly=True,
        secure=True,
        samesite="Lax"
    )
    response.set_cookie(
        key="refresh_token",
        value=tokens["refresh_token"],
        httponly=True,
        secure=True,
        samesite="Lax"
    )

    return response