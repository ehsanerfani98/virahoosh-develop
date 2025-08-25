from logging.config import fileConfig
from sqlalchemy import engine_from_config, pool
from alembic import context
import os
import sys
from sqlalchemy import create_engine

# اضافه کردن مسیر پروژه
sys.path.append(os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))

from database.session import Base
from models import user, token, otp, role, permission, user_role, refreshtoken, ratelimit, ai, aiinput, ai_archive, file_upload, assistant,UserSubscription, subscription_plan, user_token,payment
from core.config import DATABASE_URL


config = context.config

# 👇 این خط باعث می‌شه URL از .env بیاد نه alembic.ini
# config.set_main_option("sqlalchemy.url", DATABASE_URL)

# Logging
if config.config_file_name is not None:
    fileConfig(config.config_file_name)

target_metadata = Base.metadata

def run_migrations_offline() -> None:
    url = config.get_main_option("sqlalchemy.url")
    context.configure(
        url=url,
        target_metadata=target_metadata,
        literal_binds=True,
        dialect_opts={"paramstyle": "named"},
    )
    with context.begin_transaction():
        context.run_migrations()

def run_migrations_online() -> None:
    connectable = create_engine(
        DATABASE_URL,
        poolclass=pool.NullPool,
    )

    with connectable.connect() as connection:
        context.configure(connection=connection, target_metadata=target_metadata)

        with context.begin_transaction():
            context.run_migrations()

if context.is_offline_mode():
    run_migrations_offline()
else:
    run_migrations_online()
