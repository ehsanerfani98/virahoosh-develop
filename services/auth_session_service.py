# services/auth_session_service.py
from fastapi import Request, HTTPException
from sqlalchemy.orm import Session
from utils.token import verify_jwt_token
from models.user import User
from crud.token import is_token_valid


def auth(request: Request, db: Session) -> User:
    access_token = request.cookies.get("access_token")
    if not access_token:
        raise HTTPException(status_code=401, detail="توکن در کوکی یافت نشد")

    payload = verify_jwt_token(access_token, token_type="access")

    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(status_code=401, detail="شناسه کاربر در توکن یافت نشد")

    if payload.get("type") != "access":
        raise HTTPException(status_code=401, detail="نوع توکن نادرست است")

    if not is_token_valid(db, access_token):
        raise HTTPException(status_code=403, detail="توکن معتبر نیست")

    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        raise HTTPException(status_code=404, detail="کاربر یافت نشد")

    return user