# utils/auth.py

from fastapi import WebSocket, WebSocketException, status
from jose import jwt, JWTError
from core.config import SECRET_KEY, ALGORITHM

async def websocket_auth(websocket: WebSocket) -> dict:
    token = websocket.query_params.get("token")
    if not token:
        raise WebSocketException(code=status.WS_1008_POLICY_VIOLATION, reason="Missing token")

    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except JWTError:
        raise WebSocketException(code=status.WS_1008_POLICY_VIOLATION, reason="Invalid token")
