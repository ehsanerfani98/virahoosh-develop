# utils/rate_limiter.py
from datetime import datetime, timedelta, timezone
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from models.ratelimit import RateLimit
from core.config import TEHRAN_TZ

def rate_limiter_by_ip(ip: str, db: Session, limit: int = 5, window_seconds: int = 60):
    now = datetime.now(TEHRAN_TZ)
    window_start = now - timedelta(seconds=window_seconds)

    rate = db.query(RateLimit).filter(RateLimit.ip == ip).first()

    if rate:
        last_req = rate.last_request.replace(tzinfo=None).astimezone(TEHRAN_TZ)

        if last_req < window_start:
            rate.request_count = 1
            rate.last_request = now
        else:
            if rate.request_count >= limit:
                raise HTTPException(
                    status_code=status.HTTP_429_TOO_MANY_REQUESTS,
                    detail="درخواست بیش‌ازحد مجاز. لطفاً بعداً تلاش کنید."
                )
            rate.request_count += 1
            rate.last_request = now
    else:
        rate = RateLimit(ip=ip, request_count=1, last_request=now)
        db.add(rate)

    db.commit()
