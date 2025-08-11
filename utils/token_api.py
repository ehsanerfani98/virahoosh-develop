from fastapi import Request
from sqlalchemy.orm import Session
from models.user_token import UserToken
from controllers.auth_controller import get_current_user
from database.session import SessionLocal
import tiktoken

def get_tokens_used(db: Session, user_id: str) -> int:
    user_token = db.query(UserToken).filter(UserToken.user_id == user_id).first()
    return user_token.tokens_used if user_token else 0

def tokens_used_global(request: Request) -> int:
    db = SessionLocal()
    try:
        token = None
        user = None
        token = request.cookies.get("access_token")
        if token:
            user = get_current_user(token=token, db=db)
        if user:
            return get_tokens_used(db, user.id)
        return 0
    finally:
        db.close()

def num_tokens_from_messages(messages, model_name):
    encoding = tiktoken.encoding_for_model(model_name)
    tokens_per_message = 3
    tokens_per_name = 1
    num_tokens = 0
    for msg in messages:
        num_tokens += tokens_per_message
        for key, value in msg.items():
            num_tokens += len(encoding.encode(value))
            if key == "name":
                num_tokens += tokens_per_name
    num_tokens += 3
    return num_tokens

