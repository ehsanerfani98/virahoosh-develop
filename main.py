# main.py

from fastapi import FastAPI, Request, HTTPException
from fastapi.responses import HTMLResponse
from fastapi.staticfiles import StaticFiles
from routers import auth, public, role, admin
from middlewares.auth_required import AuthRequiredMiddleware
from middlewares.permissions import PermissionMiddleware
from fastapi.middleware import Middleware
from core.templates import templates
from starlette.exceptions import HTTPException as StarletteHTTPException
from models.permission import Permission


app = FastAPI(
    title="سامانه ویراهوش",
    version="1.0.0",
    middleware=[
        Middleware(AuthRequiredMiddleware),
        Middleware(PermissionMiddleware)
    ],
    docs_url=None,       
    redoc_url=None,       
    openapi_url=None     
)


# from sqlalchemy.orm import Session
# from database.session import get_db
# from models.permission import Permission

# entities = {
#     "user": "کاربر",
#     "role": "نقش",
#     "permission": "مجوز",
#     "ai": "هوش مصنوعی",
# }

# actions = {
#     "list": "لیست",
#     "create": "ایجاد",
#     "edit": "ویرایش",
#     "delete": "حذف",
# }

# def seed_permissions(db: Session):
#     for entity, entity_fa in entities.items():
#         for action, action_fa in actions.items():
#             name = f"{action}_{entity}"
#             title = f"{action_fa} {entity_fa}"

#             existing = db.query(Permission).filter_by(name=name).first()
#             if not existing:
#                 permission = Permission(name=name, title=title)
#                 db.add(permission)
#     db.commit()

# # گرفتن session به درستی از generator
# db = next(get_db())
# seed_permissions(db)
# db.close()


@app.exception_handler(StarletteHTTPException)
async def custom_http_exception_handler(request: Request, exc: StarletteHTTPException):
    if exc.status_code in [403, 404, 500]:
        return templates.TemplateResponse(
            f"errors/{exc.status_code}.html",
            {"request": request, "detail": exc.detail},
            status_code=exc.status_code
        )
    return HTMLResponse(
        content=f"<h1>{exc.status_code} - {exc.detail}</h1>",
        status_code=exc.status_code
    )

app.mount("/static", StaticFiles(directory="static"), name="static")

# ثبت روت‌ها
app.include_router(public.router_site)
app.include_router(auth.router_auth)
app.include_router(auth.router_otp)
app.include_router(admin.router)
app.include_router(role.router)
