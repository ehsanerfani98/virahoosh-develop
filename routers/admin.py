# routers/admin.py
from fastapi import APIRouter, Depends, Request, HTTPException, Form, Query, UploadFile, WebSocket, WebSocketDisconnect
from core.templates import templates
from fastapi.responses import HTMLResponse, RedirectResponse, JSONResponse
from services.auth_session_service import auth
from sqlalchemy.orm import Session, joinedload
from database.session import get_db
from models.role import Role
from models.permission import Permission
from models.file_upload import FileUpload
from models.user import User
from models.assistant import Assistant
from models.ai import AiModel
from models.aiinput import AiInput
from starlette.status import HTTP_302_FOUND
from passlib.hash import bcrypt
from services.permission_service import has_permission, user_has_role
from sqlalchemy import desc
from typing import List
import json
from services.openai_service import run_openai_prompt, generate_image_by_prompt, translate_to_english, text_to_speech, analyze_image_with_openai_vision, realtime_audio_relay
from models.ai_archive import AiArchive
from starlette.concurrency import run_in_threadpool
from datetime import datetime
from core.config import TEHRAN_TZ
import os
from io import BytesIO
from PIL import Image
import base64
from utils.file_upload import upload_file, upload_file_from_bytes, check_user_storage_limit
import requests
from utils.auth import websocket_auth
from utils.token import get_token
from starlette.websockets import WebSocketState
import logging
from services.tasks import process_excel_file
import shutil
import uuid

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


router = APIRouter(prefix="/admin", tags=["admin"])


@router.get("/dashboard", response_class=HTMLResponse, name="admin_dashboard")
def dashboard(request: Request, db: Session = Depends(get_db)):
    user = auth(request, db)
    return templates.TemplateResponse("admin/dashboard/index.html", {"request": request, "user": user})

# روت نقش ها


@router.get("/roles", response_class=HTMLResponse, name="admin_roles")
def roles_list(
    request: Request,
    db: Session = Depends(get_db),
    _=Depends(has_permission("list_role")),
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100)
):
    total = db.query(Role).count()
    roles = db.query(Role).order_by(desc(Role.id)).offset(
        (page - 1) * per_page).limit(per_page).all()

    total_pages = (total + per_page - 1) // per_page

    return templates.TemplateResponse("admin/roles/index.html", {
        "request": request,
        "roles": roles,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
    })


@router.get("/roles/{role_id}/edit", response_class=HTMLResponse, name="admin_roles_edit")
def edit_role(role_id: int, request: Request, db: Session = Depends(get_db), _=Depends(has_permission("edit_role"))):
    role = db.query(Role).filter(Role.id == role_id).first()
    permissions = db.query(Permission).all()
    if not role:
        raise HTTPException(status_code=404, detail="Role not found")
    return templates.TemplateResponse(
        "admin/roles/edit.html",
        {"request": request, "role": role, "permissions": permissions}
    )


@router.post("/roles/{role_id}/edit", name="admin_roles_update")
def update_role(
    request: Request,
    role_id: int,
    name: str = Form(...),
    title: str = Form(...),
    permission_ids: list[int] = Form([]),
    db: Session = Depends(get_db),
    _=Depends(has_permission("edit_role")),
):
    role = db.query(Role).filter(Role.id == role_id).first()
    if not role:
        raise HTTPException(status_code=404, detail="Role not found")

    role.name = name
    role.title = title
    # به‌روزرسانی مجوزها
    role.permissions = db.query(Permission).filter(
        Permission.id.in_(permission_ids)).all()
    db.commit()

    return RedirectResponse(url=request.url_for("admin_roles"), status_code=HTTP_302_FOUND)


@router.get("/roles/create", response_class=HTMLResponse, name="admin_roles_create")
def create_role_page(request: Request, db: Session = Depends(get_db), _=Depends(has_permission("create_role"))):
    permissions = db.query(Permission).all()
    return templates.TemplateResponse(
        "admin/roles/create.html",
        {"request": request, "permissions": permissions}
    )


@router.post("/roles/create", name="admin_roles_store")
def store_role(
    request: Request,
    name: str = Form(...),
    title: str = Form(...),
    permission_ids: list[int] = Form([]),
    db: Session = Depends(get_db),
    _=Depends(has_permission("create_role")),
):
    role = Role(name=name, title=title)
    role.permissions = db.query(Permission).filter(
        Permission.id.in_(permission_ids)).all()
    db.add(role)
    db.commit()
    return RedirectResponse(url=request.url_for("admin_roles"), status_code=HTTP_302_FOUND)


@router.post("/roles/{role_id}/delete", name="admin_roles_delete")
def delete_role(request: Request, role_id: int, db: Session = Depends(get_db), _=Depends(has_permission("delete_role"))):

    role = db.query(Role).options(joinedload(Role.users)
                                  ).filter(Role.id == role_id).first()

    if not role:
        raise HTTPException(status_code=404, detail="نقش مورد نظر پیدا نشد.")

    if role.users:
        return JSONResponse(
            status_code=400,
            content={
                "message": "این نقش به کاربرانی اختصاص داده شده و قابل حذف نیست."}
        )

    db.delete(role)
    db.commit()

    return JSONResponse(
        status_code=200,
        content={"message": "نقش با موفقیت حذف شد."}
    )

# روت مجوزها


@router.get("/permissions", response_class=HTMLResponse, name="admin_permissions")
def list_permissions(
    request: Request,
    db: Session = Depends(get_db),
    _=Depends(has_permission("list_permission")),
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100)
):
    total = db.query(Permission).count()
    permissions = db.query(Permission).order_by(desc(Permission.id)).offset(
        (page - 1) * per_page).limit(per_page).all()

    total_pages = (total + per_page - 1) // per_page

    return templates.TemplateResponse("admin/permissions/index.html", {
        "request": request,
        "permissions": permissions,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
    })


@router.get("/permissions/create", response_class=HTMLResponse, name="admin_permissions_create")
def create_permission_page(request: Request, db: Session = Depends(get_db), _=Depends(has_permission("create_permission"))):
    return templates.TemplateResponse("admin/permissions/create.html", {"request": request})


@router.post("/permissions/create", name="admin_permissions_store")
def store_permission(
    request: Request,
    name: str = Form(...),
    title: str = Form(...),
    db: Session = Depends(get_db),
    _=Depends(has_permission("create_permission")),
):
    exists_name = db.query(Permission).filter(Permission.name == name).first()
    exists_title = db.query(Permission).filter(
        Permission.title == title).first()
    if exists_name or exists_title:
        raise HTTPException(
            status_code=400, detail="نام یا عنوان مجوز تکراری است.")

    permission = Permission(name=name, title=title)
    db.add(permission)
    db.commit()
    db.refresh(permission)

    # ریدایرکت به لیست مجوزها
    return RedirectResponse(url=request.url_for("admin_permissions"), status_code=HTTP_302_FOUND)


@router.get("/permissions/{permission_id}/edit", response_class=HTMLResponse, name="admin_permissions_edit")
def edit_permission_page(permission_id: int, request: Request, db: Session = Depends(get_db), _=Depends(has_permission("edit_permission"))):
    permission = db.query(Permission).filter(
        Permission.id == permission_id).first()
    if not permission:
        raise HTTPException(status_code=404, detail="مجوز پیدا نشد.")
    return templates.TemplateResponse(
        "admin/permissions/edit.html",
        {"request": request, "permission": permission}
    )


@router.post("/permissions/{permission_id}/edit", name="admin_permissions_update")
def update_permission(
    request: Request,
    permission_id: int,
    name: str = Form(...),
    title: str = Form(...),
    db: Session = Depends(get_db),
    _=Depends(has_permission("edit_permission")),
):
    permission = db.query(Permission).filter(
        Permission.id == permission_id).first()
    if not permission:
        raise HTTPException(status_code=404, detail="مجوز پیدا نشد.")

    exists_name = db.query(Permission).filter(
        Permission.name == name, Permission.id != permission_id).first()
    exists_title = db.query(Permission).filter(
        Permission.title == title, Permission.id != permission_id).first()
    if exists_name or exists_title:
        raise HTTPException(
            status_code=400, detail="نام یا عنوان مجوز تکراری است.")

    permission.name = name
    permission.title = title
    db.commit()
    db.refresh(permission)

    return RedirectResponse(url=request.url_for("admin_permissions"), status_code=302)


@router.post("/permissions/{permission_id}/delete", name="admin_permissions_delete")
def delete_permission(request: Request, permission_id: int, db: Session = Depends(get_db), _=Depends(has_permission("delete_permission"))):
    permission = db.query(Permission).filter(
        Permission.id == permission_id).first()

    if not permission:
        return JSONResponse(status_code=404, content={"message": "مجوز پیدا نشد."})

    # ✅ بررسی اتصال به نقش‌ها
    if permission.roles and len(permission.roles) > 0:
        role_titles = ", ".join([r.title for r in permission.roles])
        return JSONResponse(
            status_code=400,
            content={
                "message": f"مجوز مورد نظر به نقش‌های ( {role_titles} ) متصل است و قابل حذف نیست"}
        )

    db.delete(permission)
    db.commit()

    return JSONResponse(
        status_code=200,
        content={"message": "مجوز با موفقیت حذف شد."}
    )

# روت کاربران


@router.get("/users", response_class=HTMLResponse, name="admin_users")
def list_users(
    request: Request,
    db: Session = Depends(get_db),
    _=Depends(has_permission("list_user")),
    page: int = Query(1, ge=1),
    per_page: int = Query(10, ge=1, le=100)
):
    total = db.query(User).count()
    users = db.query(User).order_by(desc(User.id)).offset(
        (page - 1) * per_page).limit(per_page).all()

    total_pages = (total + per_page - 1) // per_page

    return templates.TemplateResponse("admin/users/index.html", {
        "request": request,
        "users": users,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages,
    })


@router.get("/users/create", response_class=HTMLResponse, name="admin_users_create")
def create_user_page(request: Request, db: Session = Depends(get_db), _=Depends(has_permission("create_user"))):
    roles = db.query(Role).all()
    return templates.TemplateResponse("admin/users/create.html", {"request": request, "roles": roles})


@router.post("/users/create", name="admin_users_store")
def store_user(
    request: Request,
    email: str = Form(None),
    phone: str = Form(None),
    password: str = Form(...),
    role_ids: list[int] = Form([]),
    db: Session = Depends(get_db),
    _=Depends(has_permission("create_user")),
):
    hashed_password = bcrypt.hash(password)
    new_user = User(email=email, phone=phone, password=hashed_password)
    db.add(new_user)
    db.commit()
    db.refresh(new_user)

    # افزودن نقش‌ها
    if role_ids:
        roles = db.query(Role).filter(Role.id.in_(role_ids)).all()
        new_user.roles = roles
        db.commit()

    return RedirectResponse(url=request.url_for("admin_users"), status_code=302)


@router.get("/users/{user_id}/edit", response_class=HTMLResponse, name="admin_users_edit")
def edit_user_page(user_id: str, request: Request, db: Session = Depends(get_db), _=Depends(has_permission("edit_user"))):
    target_user = db.query(User).filter(User.id == user_id).first()
    roles = db.query(Role).all()
    return templates.TemplateResponse("admin/users/edit.html", {
        "request": request, "target_user": target_user, "roles": roles
    })


@router.post("/users/{user_id}/edit", name="admin_users_update")
def update_user(
    request: Request,
    user_id: str,
    email: str = Form(None),
    phone: str = Form(None),
    role_ids: list[int] = Form([]),
    db: Session = Depends(get_db),
    _=Depends(has_permission("edit_user")),
):
    target_user = db.query(User).filter(User.id == user_id).first()
    target_user.email = email
    target_user.phone = phone
    target_user.roles = db.query(Role).filter(Role.id.in_(role_ids)).all()
    db.commit()
    return RedirectResponse(url=request.url_for("admin_users"), status_code=302)


@router.post("/users/{user_id}/delete", name="admin_users_delete")
def delete_user(request: Request, user_id: str, db: Session = Depends(get_db), _=Depends(has_permission("delete_user")),):
    target_user = db.query(User).filter(User.id == user_id).first()
    if not target_user:
        return JSONResponse(status_code=404, content={"message": "کاربر یافت نشد."})

    db.delete(target_user)
    db.commit()
    return JSONResponse(status_code=200, content={"message": "کاربر با موفقیت حذف شد."})

# لیست مدل‌ها


@router.get("/ais", response_class=HTMLResponse, name="admin_ais")
def index(request: Request, db: Session = Depends(get_db), _: bool = Depends(has_permission("list_ai")), page: int = 1, per_page: int = 10):
    total = db.query(AiModel).count()
    ai_models = db.query(AiModel).order_by(AiModel.id.desc()).offset(
        (page - 1) * per_page).limit(per_page).all()
    total_pages = (total + per_page - 1) // per_page

    return templates.TemplateResponse("admin/ai/index.html", {
        "request": request,
        "ai_models": ai_models,
        "page": page,
        "per_page": per_page,
        "total_pages": total_pages
    })


@router.get("/ais/carts", response_class=HTMLResponse, name="admin_ais_carts")
def list_ai_carts(request: Request, db: Session = Depends(get_db), page: int = 1, per_page: int = 10):
    total = db.query(AiModel).count()
    ai_models = db.query(AiModel).order_by(AiModel.id.desc()).offset(
        (page - 1) * per_page).limit(per_page).all()
    total_pages = (total + per_page - 1) // per_page

    return templates.TemplateResponse("admin/ai/ais.html", {
        "request": request,
        "ai_models": ai_models,
        "page": page,
        "per_page": per_page,
        "total_pages": total_pages
    })


@router.get("/ais/archives", response_class=HTMLResponse, name="admin_ai_archives")
def list_ai_archives(
    request: Request,
    db: Session = Depends(get_db),
    page: int = Query(1, ge=1),
    per_page: int = Query(4, ge=1, le=100)
):
    user = auth(request, db)

    if (user_has_role(user, 'Admin')):
        total = db.query(AiArchive).count()
        archives = db.query(AiArchive).order_by(desc(AiArchive.created_at)).offset(
            (page - 1) * per_page).limit(per_page).all()
    else:
        total = db.query(AiArchive).filter(
            AiArchive.user_id == user.id).count()
        archives = db.query(AiArchive).filter(AiArchive.user_id == user.id).order_by(desc(AiArchive.created_at)).offset(
            (page - 1) * per_page).limit(per_page).all()

    total_pages = (total + per_page - 1) // per_page

    return templates.TemplateResponse("admin/ai/ai_archives.html", {
        "request": request,
        "archives": archives,
        "page": page,
        "per_page": per_page,
        "total": total,
        "total_pages": total_pages
    })


@router.get("/ais/create", response_class=HTMLResponse, name="admin_ai_create")
def create_page(request: Request, _: bool = Depends(has_permission("create_ai"))):
    return templates.TemplateResponse("admin/ai/create.html", {"request": request})


@router.post("/ais/create", name="admin_ai_store")
def create(
    request: Request,
    icon: str = Form(...),
    title: str = Form(...),
    description: str = Form(""),
    provider: str = Form(""),
    model: str = Form(""),
    prompt: str = Form(""),
    system_prompt: str = Form(""),
    max_tokens: int = Form(""),
    type: str = Form(""),
    inputs: List[str] = Form([]),
    db: Session = Depends(get_db),
    _: bool = Depends(has_permission("create_ai"))
):
    # ساخت مدل اصلی
    ai_model = AiModel(
        icon=icon,
        title=title,
        description=description,
        provider=provider,
        model=model,
        prompt=prompt,
        system_prompt=system_prompt,
        max_tokens=max_tokens,
        type=type,
    )
    db.add(ai_model)
    db.commit()
    db.refresh(ai_model)

    # ذخیره ورودی‌ها
    for item in inputs:
        try:
            data = json.loads(item)

            options = data.get("options", None)
            if options:
                # اگر options رشته است (مثلا "a, b, c")
                if isinstance(options, str):
                    options_list = [opt.strip()
                                    for opt in options.split(",") if opt.strip()]
                # اگر options از قبل لیست است
                elif isinstance(options, list):
                    options_list = options
                else:
                    options_list = []

                options_json = json.dumps(options_list, ensure_ascii=False)
            else:
                options_json = None

            db.add(AiInput(
                ai_model_id=ai_model.id,
                title=data["title"],
                name=data["name"],
                input_type=data["input_type"],
                options=options_json
            ))
        except Exception as e:
            print(f"خطا در ذخیره ورودی: {e}")
            continue

    db.commit()

    return RedirectResponse(url=request.url_for("admin_ais"), status_code=302)


@router.get("/ais/{ai_id}/edit", response_class=HTMLResponse, name="admin_ai_edit")
def edit_page(ai_id: int, request: Request, db: Session = Depends(get_db), _: bool = Depends(has_permission("edit_ai"))):
    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        raise HTTPException(status_code=404, detail="مدل یافت نشد")

    return templates.TemplateResponse("admin/ai/edit.html", {
        "request": request,
        "ai_model": ai_model
    })


@router.post("/ais/{ai_id}/edit", name="admin_ai_update")
def update(
    ai_id: int,
    request: Request,
    icon: str = Form(...),
    title: str = Form(...),
    description: str = Form(""),
    provider: str = Form(""),
    model: str = Form(""),
    prompt: str = Form(""),
    system_prompt: str = Form(""),
    max_tokens: int = Form(""),
    type: str = Form(""),
    inputs: List[str] = Form([]),
    db: Session = Depends(get_db),
    _: bool = Depends(has_permission("edit_ai"))
):
    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        raise HTTPException(status_code=404, detail="مدل یافت نشد")

    ai_model.icon = icon
    ai_model.title = title
    ai_model.description = description
    ai_model.provider = provider
    ai_model.model = model
    ai_model.prompt = prompt
    ai_model.system_prompt = system_prompt
    ai_model.max_tokens = max_tokens
    ai_model.type = type

    # حذف ورودی‌های قبلی
    db.query(AiInput).filter(AiInput.ai_model_id == ai_model.id).delete()

    for item in inputs:
        try:
            data = json.loads(item)

            input_obj = AiInput(
                ai_model_id=ai_model.id,
                title=data["title"],
                name=data["name"],
                input_type=data["input_type"]
            )

            if data["input_type"] in ["select", "checkbox", "radiobutton"]:
                raw_options = data.get("options", "")
                if isinstance(raw_options, str):
                    options_list = [opt.strip()
                                    for opt in raw_options.split(",") if opt.strip()]
                    input_obj.options = json.dumps(
                        options_list)  # ذخیره به صورت JSON
                elif isinstance(raw_options, list):
                    input_obj.options = json.dumps(
                        raw_options, ensure_ascii=False)

            db.add(input_obj)
        except Exception as e:
            print("خطا در ذخیره ورودی:", e)
            continue

    db.commit()
    return RedirectResponse(url=request.url_for("admin_ais"), status_code=302)


@router.post("/ais/{ai_id}/delete", name="admin_ai_delete")
def delete(ai_id: int, db: Session = Depends(get_db), _: bool = Depends(has_permission("delete_ai"))):
    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        return JSONResponse(status_code=404, content={"message": "مدل یافت نشد."})

    db.delete(ai_model)
    db.commit()
    return JSONResponse(status_code=200, content={"message": "مدل با موفقیت حذف شد."})


@router.get("/ais/{ai_id}", response_class=HTMLResponse, name="admin_ai_model")
def ai_form(ai_id: int, request: Request, db: Session = Depends(get_db)):
    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        return HTMLResponse("مدل یافت نشد", status_code=404)
    return templates.TemplateResponse("admin/ai/ai_form.html", {
        "request": request,
        "ai_model": ai_model,
        "token": get_token(request),
        "result": None
    })


@router.post("/ais/{ai_id}/generate-text", name="admin_ai_generate_text")
async def generate_text(ai_id: int, request: Request, db: Session = Depends(get_db)):
    form = await request.form()
    form_data = dict(form)

    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        return JSONResponse(status_code=404, content={"message": "مدل یافت نشد"})

    prompt_filled = ai_model.prompt
    model = ai_model.model
    provider = ai_model.provider
    for input_item in ai_model.inputs:
        value = form_data.get(input_item.name, "")
        prompt_filled = prompt_filled.replace(
            "{" + input_item.name + "}", value)

    system_prompt = ai_model.system_prompt or "تو یک دستیار فارسی هستی."
    max_tokens = ai_model.max_tokens or 1000

    text_response = await run_in_threadpool(run_openai_prompt, prompt_filled, system_prompt, max_tokens, model, provider)

    user = auth(request, db)
    archive = AiArchive(
        user_id=user.id,
        ai_model_id=ai_id,
        title="",
        type="image",
        prompt=prompt_filled,
        url="",
        response=text_response,
        created_at=datetime.now(TEHRAN_TZ)
    )
    db.add(archive)
    db.commit()

    return JSONResponse({
        "response": text_response,
        "prompt": prompt_filled,
        "model_id": ai_id
    })


@router.post("/ais/{ai_id}/generate-image", name="admin_ai_generate_image")
async def generate_image(ai_id: int, request: Request, db: Session = Depends(get_db)):
    form = await request.form()
    form_data = dict(form)
    user = auth(request, db)

    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        return JSONResponse(status_code=404, content={"message": "مدل یافت نشد"})

    image_title = form_data.get("image_title", "").strip()
    if not image_title:
        return JSONResponse(status_code=400, content={"message": "درخواست ساخت تصویر متوقف شد"})

    prompt_filled = ai_model.prompt
    for input_item in ai_model.inputs:
        value = form_data.get(input_item.name, "")
        prompt_filled = prompt_filled.replace(f"{{{input_item.name}}}", value)

    image_prompt = prompt_filled + \
        " سپس با توجه به توضیحات تصویر را تولید کن ، توضیحات : " + image_title

    model = ai_model.model
    provider = ai_model.provider
    translated_prompt = await run_in_threadpool(translate_to_english, image_prompt, model, provider)
    image_url = await run_in_threadpool(generate_image_by_prompt, translated_prompt)

    if not image_url:
        return JSONResponse(status_code=500, content={"message": "خطا در تولید تصویر"})

    try:
        response = requests.get(image_url)
        response.raise_for_status()
        image_bytes = response.content
        try:
            check_user_storage_limit(
                user_id=user.id, additional_size=len(image_bytes))
        except HTTPException as e:
            return JSONResponse(
                status_code=403,
                content={
                    "message": "فضای ذخیره‌سازی شما کافی نیست و ما نمی توانیم تصویر تولید شده را در سیستم خود ذخیره کنیم. لطفا بعد از تولید تصویر آن را در دستگاه خود ذخیره کنید",
                    "image_url": image_url,
                    "prompt": image_prompt,
                    "translated_prompt": translated_prompt,
                    "model_id": ai_id
                }
            )

        filename = f"{datetime.now().strftime('%Y%m%d%H%M%S')}.png"
        content_type = response.headers.get("Content-Type", "image/png")

        saved_path = upload_file_from_bytes(
            user_id=user.id,
            filename=filename,
            content_type=content_type,
            file_bytes=image_bytes,
            db=db,
            save_to_db=True
        )

    except Exception as e:
        return JSONResponse(status_code=500, content={"message": f"خطا در ذخیره فایل: {str(e)}"})

    archive = AiArchive(
        user_id=user.id,
        ai_model_id=ai_id,
        title=image_title,
        type="image",
        prompt=image_prompt,
        url=saved_path,
        response=None,
        created_at=datetime.now(TEHRAN_TZ),
    )
    db.add(archive)
    db.commit()

    return JSONResponse({
        "image_url": image_url,
        "prompt": image_prompt,
        "translated_prompt": translated_prompt,
        "model_id": ai_id
    })


@router.post("/ais/{ai_id}/generate-text-audio", name="admin_ai_generate_text_audio")
async def generate_text_audio(ai_id: int, request: Request, db: Session = Depends(get_db)):
    form = await request.form()
    form_data = dict(form)

    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        return JSONResponse(status_code=404, content={"message": "مدل یافت نشد"})

    title = form_data.get("text_title", "").strip()
    voice = form_data.get("text_voice", "").strip()
    instructions = form_data.get("text_instructions", "").strip()
    response_format = form_data.get("text_response_format", "mp3").strip()
    if not title:
        return JSONResponse(status_code=400, content={"message": "عنوان متن برای تبدیل به صدا مشخص نشده است"})

    model = ai_model.model
    provider = ai_model.provider
    user = auth(request, db)

    filename = f"tts_output_{ai_id}_{int(datetime.now().timestamp())}.{response_format}"

    temp_audio_path = f"static/audio/{user.id}/{filename}"
    os.makedirs(os.path.dirname(temp_audio_path), exist_ok=True)

    audio_path_or_error = text_to_speech(
        input_text=title,
        model=model,
        voice=voice,
        output_path=temp_audio_path,
        format=response_format,
        instructions=instructions
    )

    if audio_path_or_error.startswith("خطا"):
        return JSONResponse(status_code=500, content={"message": audio_path_or_error})

    with open(temp_audio_path, "rb") as f:
        audio_bytes = f.read()

    try:
        saved_path = upload_file_from_bytes(
            user_id=user.id,
            filename=filename,
            file_bytes=audio_bytes,
            db=db,
            save_to_db=True,
            content_type=f"audio/{response_format}",
        )
        db.commit()  # کامیت تراکنش ذخیره فایل
    except HTTPException as e:
        return JSONResponse(status_code=e.status_code, content={"message": e.detail})

    # ذخیره در آرشیو AiArchive
    archive = AiArchive(
        user_id=user.id,
        ai_model_id=ai_id,
        title=title,
        type="audio",
        prompt="",
        response="",
        url=saved_path,
        created_at=datetime.now(TEHRAN_TZ)
    )
    db.add(archive)
    db.commit()

    # حذف فایل موقت (اختیاری)
    try:
        os.remove(temp_audio_path)
    except Exception:
        pass

    return JSONResponse({
        "response": "text_response",
        "audio_url": f"/{saved_path}"
    })


@router.post("/ais/{ai_id}/vision-image", name="admin_ai_vision_image")
async def generate_vision_image(ai_id: int, request: Request, db: Session = Depends(get_db)):
    form = await request.form()
    form_data = dict(form)

    # مدل را از دیتابیس بگیر
    ai_model = db.query(AiModel).filter(AiModel.id == ai_id).first()
    if not ai_model:
        return JSONResponse(status_code=404, content={"message": "مدل یافت نشد"})

    user = auth(request, db)

    # دریافت فایل و عنوان
    image_file: UploadFile = form.get("file")
    vision_title = form_data.get("vision_title", "").strip()

    if not image_file or not vision_title:
        return JSONResponse(status_code=400, content={"message": "فایل یا عنوان تصویر ارسال نشده است"})

    # آپلود فایل و ذخیره در دیتابیس
    try:
        saved_file_path = await upload_file(
            file=image_file,
            user_id=user.id,
            db=db,
            save_to_db=True,
        )
    except Exception as e:
        return JSONResponse(status_code=400, content={"message": f"خطا در آپلود فایل: {str(e)}"})

    # خواندن فایل برای ارسال به GPT-4 Vision
    with open(saved_file_path, "rb") as f:
        image_bytes = f.read()
    image = Image.open(BytesIO(image_bytes))

    # اجرای مدل بینایی
    prompt_text = vision_title
    result_text = await run_in_threadpool(
        analyze_image_with_openai_vision,
        image=image,
        max_tokens=ai_model.max_tokens,
        prompt=prompt_text,
        model=ai_model.model,
    )

    # ذخیره در آرشیو
    archive = AiArchive(
        user_id=user.id,
        ai_model_id=ai_id,
        title=vision_title,
        type="vision",
        prompt=prompt_text,
        url=saved_file_path,
        response=result_text,
        created_at=datetime.now(TEHRAN_TZ),
    )
    db.add(archive)
    db.commit()

    # آماده‌سازی Base64 برای نمایش در مرورگر
    image_base64 = base64.b64encode(image_bytes).decode("utf-8")
    image_data_url = f"data:{image_file.content_type};base64,{image_base64}"

    return JSONResponse({
        "result": result_text,
        "prompt": prompt_text,
        "model_id": ai_id,
        "image_url": image_data_url,
    })


# @router.post("/ais/archive/save", name="admin_ai_archive_save")
# def save_to_archive(
#     request: Request,
#     ai_model_id: int = Form(...),
#     prompt: str = Form(...),
#     title: str = Form(...),
#     response: str = Form(...),
#     db: Session = Depends(get_db),
# ):

#     user = auth(request, db)
#     archive = AiArchive(ai_model_id=ai_model_id, user_id=user.id,
#                         title=title, prompt=prompt, response=response)
#     db.add(archive)
#     db.commit()
#     return RedirectResponse(url=f"/admin/ais/{ai_model_id}", status_code=302)


@router.post("/ais/archive/{archive_id}/delete", name="admin_ais_archive_delete")
def delete_archive(
    request: Request,
    archive_id: int,
    db: Session = Depends(get_db),
    _=Depends(has_permission("delete_archive")),
):
    target_archive = db.query(AiArchive).filter(
        AiArchive.id == archive_id).first()
    if not target_archive:
        return JSONResponse(status_code=404, content={"message": "آرشیو یافت نشد."})

    # مسیر فایل آرشیو
    file_path = target_archive.url  # فرض بر این است که این همان filepath است

    # جستجوی رکورد فایل در file_uploads
    file_record = db.query(FileUpload).filter(
        FileUpload.filepath == file_path).first()

    # حذف فایل فیزیکی
    if file_path and os.path.isfile(file_path):
        try:
            os.remove(file_path)
        except Exception as e:
            print(f"خطا در حذف فایل: {e}")

    # حذف رکورد فایل از دیتابیس
    if file_record:
        try:
            db.delete(file_record)
        except Exception as e:
            print(f"خطا در حذف رکورد فایل: {e}")

    # حذف رکورد آرشیو
    db.delete(target_archive)
    db.commit()

    return JSONResponse(status_code=200, content={"message": "آرشیو و فایل مربوطه با موفقیت حذف شدند."})


@router.websocket("/ws/ais/{ai_id}/audio-chat")
async def audio_chat_ws(
    websocket: WebSocket,
    ai_id: int,
    token: str = Depends(websocket_auth),
    db: Session = Depends(get_db)
):
    await websocket.accept()
    logger.info(
        f"🎤 Audio chat WebSocket connected for AI {ai_id} from {websocket.client.host}:{websocket.client.port}")

    deployment = get_deployment_for_ai(ai_id, db)
    logger.info(f"🤖 Using deployment: {deployment}")

    try:
        await realtime_audio_relay(websocket, deployment)
    except WebSocketDisconnect:
        logger.info("🔌 WebSocket disconnected normally")
    except Exception as e:
        logger.error(f"❌ WebSocket error: {e}")
        if websocket.client_state != WebSocketState.DISCONNECTED:
            try:
                await websocket.send_json({"type": "error", "error": "Server error"})
            except:
                pass
    finally:
        if websocket.client_state != WebSocketState.DISCONNECTED:
            try:
                await websocket.close()
                logger.info("🔌 WebSocket closed")
            except:
                pass


@router.get("/assistants", response_class=HTMLResponse, name="admin_assistants")
def list_assistants(request: Request, db: Session = Depends(get_db)):
    assistants = db.query(Assistant).order_by(Assistant.id.desc()).all()
    return templates.TemplateResponse("admin/assistant/index.html", {"request": request, "assistants": assistants})


@router.get("/assistants/create", response_class=HTMLResponse, name="admin_assistant_create")
def create_page(request: Request):
    return templates.TemplateResponse("admin/assistant/create.html", {"request": request})


@router.post("/assistants/create", name="admin_assistant_store")
async def create_assistant(
    request: Request,
    title: str = Form(...),
    description: str = Form(""),
    domain: str = Form(""),
    db: Session = Depends(get_db)
):
    
    form = await request.form()

    user = auth(request, db)
    file: UploadFile = form.get("file")
    
     # آپلود فایل 
    try:
        saved_file_path = await upload_file(
            file=file,
            user_id=user.id,
            db=db,
            save_to_db=False,
        )
    except Exception as e:
        return JSONResponse(status_code=400, content={"message": f"خطا در آپلود فایل: {str(e)}"})
    
    assistant = Assistant(
        title=title,
        description=description,
        domain=domain,
        faiss_url=None,
        pkl_url=None,
        excel_url=saved_file_path,
        slug=str(uuid.uuid4())
    )
    db.add(assistant)
    db.commit()
    db.refresh(assistant)

    # ارسال تسک به صف
    process_excel_file.delay(assistant.id, saved_file_path, user.id)

    return RedirectResponse(url=request.url_for("admin_assistants"), status_code=302)


@router.get("/assistants/{assistant_id}/edit", response_class=HTMLResponse, name="admin_assistant_edit")
def edit_assistant_page(assistant_id: int, request: Request, db: Session = Depends(get_db), _: bool = Depends(has_permission("edit_assistants"))):
    assistant = db.query(Assistant).filter(
        Assistant.id == assistant_id).first()
    if not assistant:
        raise HTTPException(status_code=404, detail="دستیار یافت نشد")

    return templates.TemplateResponse("admin/assistant/edit.html", {
        "request": request,
        "assistant": assistant
    })


@router.post("/assistants/{assistant_id}/edit", name="admin_assistant_update")
def update_assistant(
    assistant_id: int,
    request: Request,
    title: str = Form(...),
    description: str = Form(""),
    domain: str = Form(""),
    db: Session = Depends(get_db),
    _: bool = Depends(has_permission("edit_assistants"))
):
    assistant = db.query(Assistant).filter(
        Assistant.id == assistant_id).first()
    if not assistant:
        raise HTTPException(status_code=404, detail="دستیار یافت نشد")

    assistant.title = title
    assistant.description = description
    assistant.domain = domain

    db.commit()
    return RedirectResponse(url=request.url_for("admin_assistants"), status_code=302)


@router.post("/assistants/{assistant_id}/delete", name="admin_assistant_delete")
def delete_assistant(request: Request, assistant_id: int, db: Session = Depends(get_db), _: bool = Depends(has_permission("delete_assistants"))):
    assistant = db.query(Assistant).filter(
        Assistant.id == assistant_id).first()
    if not assistant:
        return JSONResponse(status_code=404, content={"message": "دستیار یافت نشد."})

    user = auth(request, db)
    dir_path = f"static/uploads/user_{user.id}/vectorstores/{assistant.id}"
    if os.path.exists(dir_path):
        try:
            shutil.rmtree(dir_path)
            print(f"دایرکتوری {dir_path} با موفقیت حذف شد")
        except Exception as e:
            print(f"خطا در حذف دایرکتوری: {e}")
    else:
        print(f"دایرکتوری {dir_path} وجود ندارد")
   
    db.delete(assistant)
    db.commit()
    return JSONResponse(status_code=200, content={"message": "دستیار با موفقیت حذف شد."})





def get_deployment_for_ai(ai_id: int, db: Session) -> str:
    """
    Get the deployment model for the AI with validation
    """
    try:
        ai_model = db.get(AiModel, ai_id)
        if not ai_model:
            logger.error(f"❌ AI model {ai_id} not found")
            raise HTTPException(
                status_code=404, detail="مدل هوش مصنوعی یافت نشد")

        deployment = getattr(ai_model, 'model', 'gpt-4o-realtime-preview')
        logger.info(f"✅ Found deployment for AI {ai_id}: {deployment}")
        return deployment

    except Exception as e:
        logger.error(f"❌ Error getting deployment for AI {ai_id}: {e}")
        return "gpt-4o-realtime-preview"


async def parse_form_as_dict(request: Request):
    form = await request.form()
    return dict(form)


