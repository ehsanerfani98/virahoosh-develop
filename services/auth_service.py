# services/auth_service.py
import random
from datetime import datetime, timedelta
from fastapi import HTTPException
from sqlalchemy.orm import Session
from models.otp import OtpDB
from models.user import User
from utils.token import create_tokens, hash_token
from crud import token as token_crud
from models.token import TokenDB
from core.config import TEHRAN_TZ
from schemas.token import Token
from models.role import Role

def generate_otp():
    return f"{random.randint(100000, 999999)}"


def request_otp(phone: str, db: Session):
    recent = db.query(OtpDB).filter(
        OtpDB.phone == phone,
        OtpDB.created_at >= datetime.now(TEHRAN_TZ) - timedelta(hours=1)
    ).count()
    if recent >= 5:
        raise HTTPException(status_code=429, detail="تعداد دفعات درخواست بیش از حد مجاز است.")

    db.query(OtpDB).filter(OtpDB.phone == phone).delete()
    db.commit()

    otp_code = generate_otp()
    expire_at = datetime.now(TEHRAN_TZ) + timedelta(minutes=5)

    new_otp = OtpDB(
        phone=phone,
        otp_code=otp_code,
        expire_at=expire_at,
        is_used=False
    )
    db.add(new_otp)
    db.commit()

    return {"message": "کد تایید ارسال شد"}


def verify_otp(phone: str, otp_code: str, db: Session) -> Token:
    otp_entry = db.query(OtpDB).filter_by(
        phone=phone,
        otp_code=otp_code,
        is_used=False
    ).first()
    if not otp_entry:
        raise HTTPException(status_code=400, detail="کد تایید نادرست است")

    now_tehran = datetime.now(TEHRAN_TZ)

    if otp_entry.expire_at.tzinfo is None:
        expire_at = TEHRAN_TZ.localize(otp_entry.expire_at)
    else:
        expire_at = otp_entry.expire_at.astimezone(TEHRAN_TZ)

    if expire_at < now_tehran:
        raise HTTPException(status_code=400, detail="کد تایید منقضی شده است")

    otp_entry.is_used = True
    db.commit()

    user = db.query(User).filter_by(phone=phone).first()
    if not user:
        user = User(phone=phone)
        db.add(user)
        db.commit()
        db.refresh(user)

        role_user = db.query(Role).filter(Role.id == 2).first()
        if role_user:
            user.roles.append(role_user)
            db.commit()
            
    db.query(TokenDB).filter(TokenDB.user_id == user.id).delete()
    db.commit()

    tokens = create_tokens(user, login_type="phone")
    hashed_access_token = hash_token(tokens["access_token"])
    hashed_refresh_token = hash_token(tokens["refresh_token"])

    token_crud.save_access_token(db, hashed_access_token, user.id)
    token_crud.save_refresh_token(db, hashed_refresh_token, user.id)

    return Token(
        access_token=tokens["access_token"],
        refresh_token=tokens["refresh_token"],
        token_type="bearer"
    )
