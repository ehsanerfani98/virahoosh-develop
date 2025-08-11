# core/config.py
import pytz
import os
import urllib.parse
from dotenv import load_dotenv

print("Current working directory:", os.getcwd())

load_dotenv()

db_user = urllib.parse.quote_plus(os.getenv("DB_USERNAME"))
db_pass = urllib.parse.quote_plus(os.getenv("DB_PASSWORD"))

DATABASE_URL = (
    os.getenv("DB_CONNECTION") + "+pymysql://"
    + db_user + ":"
    + db_pass + "@"
    + os.getenv("DB_HOST") + ":"
    + os.getenv("DB_PORT") + "/"
    + os.getenv("DB_DATABASE")
)

SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")
AUTH_HEADER = os.getenv("AUTH_HEADER")
TOKEN_PREFIX = os.getenv("TOKEN_PREFIX")
TEHRAN_TZ = pytz.timezone("Asia/Tehran")
OPENAI_API_KEY = os.getenv("OPENAI_API_KEY")
DEEPSEEK_API_KEY = os.getenv("DEEPSEEK_API_KEY")
# MERCHANT_ID = 
# ACCESS_TOKEN = 
# SANDBOX = 

class Config:
    def __init__(self):
        self.sandbox = os.getenv("SANDBOX")
        self.merchant_id = os.getenv("MERCHANT_ID")
        self.access_token = os.getenv("ACCESS_TOKEN")
