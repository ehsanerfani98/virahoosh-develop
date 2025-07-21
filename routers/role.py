from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel
from typing import Optional, List
from database.session import get_db
from controllers import role_controller

router = APIRouter(prefix="/roles", tags=["roles"])


class RoleCreate(BaseModel):
    name: str
    title: Optional[str] = None


class PermissionCreate(BaseModel):
    name: str
    title: Optional[str] = None


class UserRoleAssign(BaseModel):
    user_id: str
    role_id: int


class RolePermissionAssign(BaseModel):
    role_id: int
    permission_id: int


@router.post("/", response_model=dict)
def create_role(role: RoleCreate, db: Session = Depends(get_db)):
    return role_controller.create_role(role.name, role.title, db)


@router.post("/permissions", response_model=dict)
def create_permission(permission: PermissionCreate, db: Session = Depends(get_db)):
    return role_controller.create_permission(permission.name, permission.title, db)


@router.post("/assign-role", response_model=dict)
def assign_role(data: UserRoleAssign, db: Session = Depends(get_db)):
    return role_controller.assign_role_to_user(data.user_id, data.role_id, db)


@router.post("/assign-permission", response_model=dict)
def assign_permission(data: RolePermissionAssign, db: Session = Depends(get_db)):
    return role_controller.add_permission_to_role(data.role_id, data.permission_id, db)


@router.get("/user/{user_id}", response_model=List[dict])
def get_user_roles(user_id: str, db: Session = Depends(get_db)):
    roles = role_controller.get_roles_for_user(user_id, db)
    return roles


@router.get("/{role_id}/permissions", response_model=List[dict])
def get_role_permissions(role_id: int, db: Session = Depends(get_db)):
    permissions = role_controller.get_permissions_for_role(role_id, db)
    return permissions
