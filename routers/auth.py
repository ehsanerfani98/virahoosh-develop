from fastapi import APIRouter, Depends, Request, Header, HTTPException, Body
from sqlalchemy.orm import Session
from jose import jwt, JWTError
from core.config import TOKEN_PREFIX, SECRET_KEY, ALGORITHM
from database.session import get_db
from models.user import User
from schemas.user import UserCreate, UserLogin
from schemas.token import Token
from controllers import auth_controller
from controllers.auth_controller import verify_token
from services.auth_service import verify_otp, request_otp
from services.permission_service import require_permission
from utils.token import create_token, hash_token
from crud import token as token_crud
from fastapi.responses import JSONResponse
from utils.rate_limiter import rate_limiter_by_ip

router_auth = APIRouter(prefix="/auth", tags=["auth"])


@router_auth.post("/signup", response_model=Token)
def signup(user: UserCreate, db: Session = Depends(get_db)):
    return auth_controller.signup_user(user, db)


@router_auth.post("/login", response_model=Token)
def login(request: Request, user: UserLogin, db: Session = Depends(get_db)):
    ip = request.client.host
    rate_limiter_by_ip(ip, db, 5, 3600)
    return auth_controller.login_user(user, db)


@router_auth.post("/logout")
def logout(request: Request, db: Session = Depends(get_db)):
    access_token = request.cookies.get("access_token")
    if not access_token:
        raise HTTPException(status_code=403, detail="توکن ارائه نشده است")
    return auth_controller.logout_user(access_token, db)


@router_auth.post("/refresh", response_model=Token)
def refresh_token(
    refresh_token: str = Body(..., embed=True),
    db: Session = Depends(get_db)
):
    # اعتبارسنجی اولیه JWT
    try:
        payload_jwt = jwt.decode(
            refresh_token, SECRET_KEY, algorithms=[ALGORITHM])
        if payload_jwt.get("type") != "refresh":
            raise HTTPException(
                status_code=401, detail="توکن Refresh معتبر نیست")
    except JWTError:
        raise HTTPException(status_code=401, detail="توکن نامعتبر است")

    # اعتبارسنجی کامل توکن با دیتابیس و کنترل‌های اضافی
    payload = verify_token(refresh_token, db, token_type="refresh")

    user_id = payload.get("sub")
    if not user_id:
        raise HTTPException(
            status_code=401, detail="شناسه کاربر در توکن موجود نیست")

    user = db.query(User).filter_by(id=user_id).first()
    if not user:
        raise HTTPException(status_code=401, detail="کاربر یافت نشد")

    # حذف توکن‌های قدیمی دسترسی
    token_crud.delete_old_access_tokens(db, user_id)

    # ساخت توکن جدید دسترسی
    new_access_token = create_token(user)
    hashed_access_token = hash_token(new_access_token)
    token_crud.save_access_token(db, hashed_access_token, user_id)

    return {
        "access_token": new_access_token,
        "refresh_token": refresh_token,
        "token_type": "bearer"
    }


@router_auth.get("/page")
def protected_route(
    authorization: str = Header(...),
    current_user: User = Depends(require_permission("ai_edit")),
    db: Session = Depends(get_db)
):
    if not authorization.startswith(TOKEN_PREFIX):
        raise HTTPException(
            status_code=403, detail="توکن معتبر ارائه نشده است")

    token = authorization[len(TOKEN_PREFIX):]
    payload = auth_controller.verify_token(token, db, token_type="access")
    return {
        "message": "اطلاعات محافظت‌شده فقط برای کاربران دارای توکن",
        "payload": payload,
        "current_user": current_user
    }


# OTP routes
router_otp = APIRouter(prefix="/otp", tags=["otp"])


@router_otp.post("/request")
def otp_request(request: Request, phone: str = Body(..., embed=True), db: Session = Depends(get_db)):
    ip = request.client.host
    rate_limiter_by_ip(ip, db, 5, 3600)
    return request_otp(phone, db)


@router_otp.post("/verify")
def otp_verify(
    request: Request,
    phone: str = Body(..., embed=True),
    code: str = Body(..., embed=True),
    db: Session = Depends(get_db)
):
    ip = request.client.host
    rate_limiter_by_ip(ip, db, 5, 3600)
    token_data = verify_otp(phone, code, db)

    response = JSONResponse(content={
        "message": "ورود موفق بود",
        "access_token": token_data.access_token,
        "refresh_token": token_data.refresh_token,
        "token_type": token_data.token_type,
    })

    # ذخیره در کوکی
    response.set_cookie(
        key="access_token",
        value=token_data.access_token,
        httponly=True,
        secure=True,
        samesite="Lax"
    )
    response.set_cookie(
        key="refresh_token",
        value=token_data.refresh_token,
        httponly=True,
        secure=True,
        samesite="Lax"
    )

    return response
