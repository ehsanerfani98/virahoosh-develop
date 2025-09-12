# routers/public.py

from fastapi import APIRouter, Depends, Request, Form, HTTPException
from core.templates import templates
from fastapi.responses import HTMLResponse, JSONResponse, StreamingResponse
from database.session import get_db
from starlette.concurrency import run_in_threadpool
from services.assistant import load_vectorstore_for_assistant
from services.openai_service import text_to_speech_stream, run_openai_prompt
from sqlalchemy.orm import Session
from models.assistant import Assistant
import uuid
from models.AssistantUserInfo import AssistantUserInfo
from typing import Annotated
from io import BytesIO


router_site = APIRouter(prefix="")


@router_site.get("/", response_class=HTMLResponse)
def root_site(request: Request):
    return templates.TemplateResponse("welcome.html", {"request": request})


@router_site.get("/login", response_class=HTMLResponse)
def login_form(request: Request):
    return templates.TemplateResponse("auth/login.html", {"request": request})


@router_site.get("/otp-login", response_class=HTMLResponse)
def login_otp_form(request: Request):
    return templates.TemplateResponse("auth/otp_login.html", {"request": request})

@router_site.get("/assistant/{slug}")
def view_assistant(request: Request, slug: str, db: Session = Depends(get_db)):
    assistant = db.query(Assistant).filter(Assistant.slug == slug).first()
    if not assistant:
        raise HTTPException(status_code=404, detail="Assistant not found")
    return templates.TemplateResponse("admin/assistant/assistant.html", {
        "request": request,
        "assistant": assistant
    })
    
@router_site.get("/iframe/assistant/{slug}")
def view_assistant(request: Request, slug: str, db: Session = Depends(get_db)):
    assistant = db.query(Assistant).filter(Assistant.slug == slug).first()
    if not assistant:
        raise HTTPException(status_code=404, detail="Assistant not found")
    return templates.TemplateResponse("admin/assistant/iframe_assistant.html", {
        "request": request,
        "assistant": assistant
    })

@router_site.post("/assistants/userinfo/store", name="assistant_user_info_store")
def store_user_info(
    request: Request,
    assistant_id: Annotated[int, Form()],
    fullname: Annotated[str, Form()],
    mobile: Annotated[str, Form()],
    email: Annotated[str, Form()],
    db: Session = Depends(get_db)
):
    assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
    if not assistant:
        raise HTTPException(status_code=404, detail="دستیار پیدا نشد")
    new_info = AssistantUserInfo(
        assistant_id=assistant_id,
        fullname=fullname,
        mobile=mobile,
        email=email,
        slug=str(uuid.uuid4())
    )
    db.add(new_info)
    db.commit()
    db.refresh(new_info)
    
    # حذف تنظیم کوکی - اکنون از localStorage استفاده می‌کنیم
    
    return JSONResponse(
        status_code=201,
        content={"message": "اطلاعات با موفقیت ذخیره شد", "id": new_info.id}
    )

@router_site.post("/assistants/{assistant_id}/ask")
async def ask_for_assistant(
    assistant_id: int,
    question: str = Form(...),
    db: Session = Depends(get_db)
):
    try:
        qa_chain, retriever = await load_vectorstore_for_assistant(db, assistant_id)
    except FileNotFoundError as e:
        return JSONResponse({"error": str(e)}, status_code=500)

    normalized_q = normalize_text(question)
    answer = await run_in_threadpool(qa_chain.run, normalized_q)
    related = await run_in_threadpool(retriever.get_relevant_documents, normalized_q)
    related_texts = [doc.page_content for doc in related]

    result = {
        "question": question,
        "answer": answer,
        "related": related_texts
    }

    return JSONResponse(result)

@router_site.post("/assistants/{assistant_id}/ask_audio")
async def ask_audio_for_assistant(
    assistant_id: int,
    question: str = Form(...),
    db: Session = Depends(get_db)
):
    try:
        qa_chain, retriever = await load_vectorstore_for_assistant(db, assistant_id)
    except FileNotFoundError as e:
        return JSONResponse({"error": str(e)}, status_code=404)

    normalized_q = normalize_text(question)

    text_response = await run_in_threadpool(
        run_openai_prompt, normalized_q, "فقط غلط املایی متن را درست کن هیچ حرف اضافه ای نزن! فقط متن را صحیح ، و ارسال کن",
        5000, "gpt-4o", "openai"
    )
    print("text_response")
    print(text_response['message'])
    answer = await run_in_threadpool(qa_chain.run, text_response['message'])

    audio_bytes = text_to_speech_stream(answer, model="gpt-4o-mini-tts", voice="shimmer", format="mp3")
    return StreamingResponse(BytesIO(audio_bytes), media_type="audio/mpeg")



def normalize_text(text: str) -> str:
    mapping = str.maketrans("۰۱۲۳۴۵۶۷۸۹", "0123456789")
    return text.translate(mapping)

