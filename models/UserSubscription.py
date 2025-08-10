# models/user_subscription.py
from sqlalchemy import Column, String, ForeignKey, DateTime, Boolean
from sqlalchemy.orm import relationship
from database.session import Base
import uuid
from datetime import datetime, timedelta
from core.config import TEHRAN_TZ

class UserSubscription(Base):
    __tablename__ = "user_subscriptions"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), unique=True, index=True)
    
    user_id = Column(String(36), ForeignKey("users.id"), nullable=False, index=True)
    user = relationship("User", back_populates="subscriptions")
    
    plan_id = Column(String(36), ForeignKey("subscription_plans.id"), nullable=False)
    plan = relationship("SubscriptionPlan")
    
    start_date = Column(DateTime, default=datetime.now(TEHRAN_TZ), nullable=False)
    end_date = Column(DateTime, nullable=False)
    
    active = Column(Boolean, default=True, nullable=False)
    
    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        if not self.end_date and self.plan:
            self.end_date = self.start_date + timedelta(days=self.plan.duration_days)
