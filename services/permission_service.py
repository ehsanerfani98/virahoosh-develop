# services/permission_service.py
from fastapi import Depends, HTTPException, status
from sqlalchemy.orm import Session
from typing import List

from database.session import get_db
from controllers.auth_controller import get_current_user
from models.user import User


def has_role(required_roles: List[str]):
    def dependency(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
        user_roles = [role.name for role in user.roles]
        if not any(role in user_roles for role in required_roles):
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="دسترسی غیرمجاز")
    return dependency

def has_permission(permission_name: str):
    def dependency(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
        user_permissions = set()
        for role in user.roles:
            for perm in role.permissions:
                user_permissions.add(perm.name)

        if permission_name not in user_permissions:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail="اجازه دسترسی ندارید")
    return dependency

def user_has_role(user: User, role_name: str) -> bool:
    return any(role.name == role_name for role in user.roles)

def user_has_permission(user: User, permission_name: str) -> bool:
    return any(perm.name == permission_name for role in user.roles for perm in role.permissions)

def require_role(role_name: str):
    def dependency(user: User = Depends(get_current_user)):
        if not user_has_role(user, role_name):
            raise HTTPException(status_code=403, detail="شما به این بخش دسترسی ندارید")
        return user
    return dependency

def require_permission(permission_name: str):
    def dependency(user: User = Depends(get_current_user)):
        if not user_has_permission(user, permission_name):
            raise HTTPException(status_code=403, detail="شما اجازه انجام این عملیات را ندارید")
        return user
    return dependency
