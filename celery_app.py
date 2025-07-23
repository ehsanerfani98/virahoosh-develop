# celery_app.py

from celery import Celery

celery_app = Celery(
    "virahoosh",
    broker="redis://localhost:6379/0",
    backend="redis://localhost:6379/0",
    include=["services.tasks"]
)

celery_app.conf.update(
    task_serializer='json',
    result_serializer='json',
    accept_content=['json'],
    timezone='Asia/Tehran',
    enable_utc=True,
)