# utils/jinja_permissions.py
from jinja2 import pass_context

@pass_context
def can(ctx, permission_name: str) -> bool:
    request = ctx.get('request')
    return permission_name in getattr(request.state, 'permissions', set())
