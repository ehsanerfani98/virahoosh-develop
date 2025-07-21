# middlewares/auth_required.py
from fastapi import Request, HTTPException
from starlette.middleware.base import BaseHTTPMiddleware
from fastapi.responses import RedirectResponse
from services.auth_session_service import auth
from database.session import get_db
from fastapi.responses import RedirectResponse
from utils.token import create_token, hash_token, verify_token
from models.user import User
from crud.token import save_access_token
from crud import token as token_crud

class AuthRequiredMiddleware(BaseHTTPMiddleware):
    async def dispatch(self, request: Request, call_next):
        if request.url.path.startswith("/admin"):
            try:
                db = next(get_db())
                try:
                    access_token = request.cookies.get("access_token")
                    try:
                        auth(request, db)
                    except HTTPException as e:
                        if e.status_code == 401:
                            refresh_token = request.cookies.get("refresh_token")
                            if refresh_token:
                                try:
                                    payload = verify_token(refresh_token, db, token_type="refresh")
                                    user_id = payload.get("sub")
                                    user = db.query(User).filter(User.id == user_id).first()

                                    token_crud.delete_old_access_tokens(db, user_id)

                                    new_access_token = create_token(user)
                                    hashed = hash_token(new_access_token)
                                    save_access_token(db, hashed, user_id)

                                    response = RedirectResponse(url=str(request.url))
                                    response.set_cookie("access_token", new_access_token, httponly=True)
                                    return response
                                except:
                                    return RedirectResponse(url="/login")
                            return RedirectResponse(url="/login")
                        else:
                            return RedirectResponse(url="/login")
                finally:
                    db.close()  # اینجا اضافه شده
            except:
                return RedirectResponse(url="/login")

        response = await call_next(request)
        return response
