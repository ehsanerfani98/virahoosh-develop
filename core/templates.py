from fastapi.templating import Jinja2Templates
from utils.jinja_permissions import can
from markupsafe import Markup
import markdown
import json
from utils.token_api import tokens_used_global

def json_loads_filter(value):
    try:
        return json.loads(value)
    except Exception:
        return []



def number_format(value, thousands_sep=','):
    try:
        value = int(float(value))  # تبدیل به عدد صحیح
    except (ValueError, TypeError):
        return value  # اگر ورودی عدد نبود همون رو برگردون

    formatted = f"{value:,}"  # جداکننده هزارگان
    if thousands_sep != ",":
        formatted = formatted.replace(",", thousands_sep)

    return formatted



templates = Jinja2Templates(directory="templates")
templates.env.globals['can'] = can
templates.env.filters["markdown"] = lambda text: Markup(markdown.markdown(text or ""))
templates.env.filters['loads'] = json_loads_filter
templates.env.globals['tokens_used'] = tokens_used_global
templates.env.filters["number_format"] = number_format
