import jwt
import datetime
from django.conf import settings
from django.contrib.auth.models import User
from rest_framework.request import Request


def create_jwt(user: User) -> str:
    payload = {
        "id": user.id,
        "exp": datetime.datetime.now(datetime.timezone.utc)
        + datetime.timedelta(hours=1),
        "iat": datetime.datetime.now(datetime.timezone.utc),
    }
    return jwt.encode(payload, settings.SECRET_KEY, algorithm="HS256")

def decode_jwt(token: str) -> dict:
    return jwt.decode(token, settings.SECRET_KEY, algorithms=["HS256"])

def get_user_from_jwt(token: str) -> User:
    payload = decode_jwt(token)
    return User.objects.get(id=payload["id"])

def validate_jwt(token: str) -> bool:
    try:
        decode_jwt(token)
        return True
    except jwt.ExpiredSignatureError:
        return False
    except jwt.InvalidTokenError:
        return False

def get_token_from_request(request: Request) -> str:
    return request.headers.get("Authorization").split(" ")[1]