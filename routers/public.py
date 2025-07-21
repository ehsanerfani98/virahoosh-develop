# routers/public.py

from fastapi import APIRouter, Depends, Request, Form, HTTPException
from core.templates import templates
from fastapi.responses import HTMLResponse, JSONResponse
from database.session import get_db
from starlette.concurrency import run_in_threadpool
from services.assistant import load_vectorstore_for_assistant
from sqlalchemy.orm import Session
from models.assistant import Assistant

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

@router_site.get("/assistant/{assistant_id}/robot")
def view_assistant(request: Request, assistant_id: int, db: Session = Depends(get_db)):
    assistant = db.query(Assistant).filter(Assistant.id == assistant_id).first()
    if not assistant:
        raise HTTPException(status_code=404, detail="Assistant not found")
    return templates.TemplateResponse("admin/assistant/assistant.html", {
        "request": request,
        "assistant": assistant
    })

@router_site.post("/assistants/{assistant_id}/ask")
async def ask_for_assistant(
    assistant_id: int,
    question: str = Form(...),
    db: Session = Depends(get_db)
):
    try:
        qa_chain, retriever = await load_vectorstore_for_assistant(db, assistant_id)
    except FileNotFoundError as e:
        return JSONResponse({"error": str(e)}, status_code=404)

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



def normalize_text(text: str) -> str:
    mapping = str.maketrans("۰۱۲۳۴۵۶۷۸۹", "0123456789")
    return text.translate(mapping)

