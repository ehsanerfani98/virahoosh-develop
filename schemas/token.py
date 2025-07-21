# schemas/token.py
from pydantic import BaseModel

# 🟢 پاسخ پس از لاگین یا ثبت‌نام موفق
class Token(BaseModel):
    access_token: str
    refresh_token: str
    token_type: str
    
# 🔐 توکن همراه اطلاعات کاربر (مثلاً برای JWT auth)
class TokenData(BaseModel):
    email: str
