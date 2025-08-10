# models/subscription_plan.py
from sqlalchemy import Column, Integer, String
from database.session import Base
import uuid

class SubscriptionPlan(Base):
    __tablename__ = "subscription_plans"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), unique=True, index=True)
    title = Column(String(255), nullable=False)          # عنوان پلن (مثلاً طلایی، نقره‌ای)
    description = Column(String(500), nullable=True)     # توضیح پلن
    
    duration_days = Column(Integer, nullable=False)       # مدت زمان اشتراک (روز)
    tokens_allowed = Column(Integer, nullable=False)      # تعداد توکن قابل استفاده
