# models/ratelimit.py
from sqlalchemy import Column, String, Integer, DateTime, func
from database.session import Base

class RateLimit(Base):
    __tablename__ = "rate_limits"
    ip = Column(String(45), primary_key=True, index=True)
    request_count = Column(Integer, default=1)
    last_request = Column(DateTime, server_default=func.now(), onupdate=func.now())