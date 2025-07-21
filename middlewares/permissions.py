# middleware/permissions.py
from starlette.middleware.base import BaseHTTPMiddleware
from controllers.auth_controller import get_current_user
from fastapi import Request
from sqlalchemy.orm import Session
from database.session import SessionLocal

class PermissionMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        db: Session = SessionLocal()

        try:
            token = request.cookies.get("access_token")
            if token:
                user = get_current_user(token=token, db=db)
                request.state.user = user
                permissions = set()
                for role in user.roles:
                    for perm in role.permissions:
                        permissions.add(perm.name)
                request.state.permissions = permissions
            else:
                request.state.user = None
                request.state.permissions = set()
        except Exception:
            request.state.user = None
            request.state.permissions = set()
        finally:
            db.close()
        response = await call_next(request)
        return response
