# schemas/user.py
from pydantic import BaseModel, EmailStr, Field
from typing import Optional

# 🟩 برای ثبت‌نام یا ساخت کاربر
class UserCreate(BaseModel):
    email: EmailStr
    password: str = Field(..., min_length=6)

# 🟩 برای ورود
class UserLogin(BaseModel):
    email: EmailStr
    password: str

# 🟦 برای پاسخ دادن اطلاعات کاربر (بدون پسورد)
class UserOut(BaseModel):
    id: int
    email: EmailStr

    class Config:
        from_attributes = True

# 🟨 برای آپدیت اطلاعات کاربر (اختیاری)
class UserUpdate(BaseModel):
    email: Optional[EmailStr] = None
    password: Optional[str] = Field(default=None, min_length=6)
