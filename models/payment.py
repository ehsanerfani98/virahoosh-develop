# models/payment.py
from sqlalchemy import Column, String, Float, Enum, ForeignKey, DateTime
from sqlalchemy.orm import relationship
from database.session import Base
import uuid
import enum
from core.config import TEHRAN_TZ
from datetime import datetime

class PaymentType(str, enum.Enum):
    wallet_topup = "wallet_topup"
    subscription_direct = "subscription_direct"
    subscription_wallet = "subscription_wallet"


class PaymentStatus(str, enum.Enum):
    pending = "pending"
    paid = "paid"
    failed = "failed"


class Payment(Base):
    __tablename__ = "payments"

    id = Column(String(36), primary_key=True, default=lambda: str(uuid.uuid4()), unique=True, index=True)

    user_id = Column(String(36), ForeignKey("users.id"), nullable=False)  
    user_subscription_id = Column(String(36), ForeignKey("user_subscriptions.id"), nullable=True)

    type = Column(Enum(PaymentType), nullable=False)
    amount = Column(Float, nullable=False)
    discount_amount = Column(Float, nullable=True)
    discount_code = Column(String(256), nullable=True)

    transaction_id = Column(String(256), nullable=True)
    invoice_number = Column(String(256), nullable=True)
    authority = Column(String(256), nullable=True)

    description = Column(String(256), nullable=True)
    status = Column(Enum(PaymentStatus), default=PaymentStatus.pending, nullable=False)

    created_at = Column(DateTime, default=lambda: datetime.now(TEHRAN_TZ))

    # روابط (در صورت نیاز)
    user = relationship("User", back_populates="payments")
    user_subscription = relationship("UserSubscription", back_populates="payments")
