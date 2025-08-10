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


templates = Jinja2Templates(directory="templates")
templates.env.globals['can'] = can
templates.env.filters["markdown"] = lambda text: Markup(markdown.markdown(text or ""))
templates.env.filters['loads'] = json_loads_filter
templates.env.globals['tokens_used'] = tokens_used_global