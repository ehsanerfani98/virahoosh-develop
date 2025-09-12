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


    try:
        # Get token from WebSocket headers
        token = websocket.headers.get("Authorization")
        if not token or not token.startswith("Bearer "):
            return None
            
        token = token.split(" ")[1]
        
        # Verify token
        user = get_token(db, token)
        if not user:
            return None
            
        return user
    except Exception as e:
        logger.error(f"WebSocket authentication error: {e}")
        return None