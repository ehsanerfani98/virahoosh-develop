# models/subscription_plan.py
from sqlalchemy import Column, Integer, String
from database.session import Base
import uuid
from sqlalchemy.orm import relationship

class SubscriptionPlan(Base):
    __tablename__ = "subscription_plans"
    
    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), unique=True, index=True)
    title = Column(String(255), nullable=False)          
    description = Column(String(500), nullable=True)    
    
    duration_days = Column(Integer, nullable=False)       
    tokens_allowed = Column(Integer, nullable=False)      
    amount = Column(String(255), nullable=False)     

    user_subscriptions = relationship("UserSubscription", back_populates="plan")
