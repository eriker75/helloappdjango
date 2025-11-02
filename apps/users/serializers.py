from typing import Any, Dict
from rest_framework import serializers
from django.contrib.auth.password_validation import validate_password
from .models import User


class RegisterSerializer(serializers.ModelSerializer[User]):
    """Serializer for user registration."""
    
    email = serializers.EmailField(required=True)
    password = serializers.CharField(write_only=True, validators=[validate_password])
    password_confirmation = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ("id", "email", "username", "password", "password_confirmation")

    def validate(self, attrs: Dict[str, Any]) -> Dict[str, Any]:
        """Validate that password and password_confirmation match."""
        if attrs["password"] != attrs["password_confirmation"]:
            raise serializers.ValidationError({"password": "Password fields didn't match."})
        return attrs

    def create(self, validated_data: Dict[str, Any]) -> User:
        """Create and return a new user."""
        validated_data.pop("password_confirmation")
        user: User = User.objects.create_user(**validated_data)
        return user


class LoginSerializer(serializers.Serializer):
    """Serializer for user login."""
    
    email = serializers.EmailField()
    password = serializers.CharField(write_only=True)


class UserSerializer(serializers.ModelSerializer[User]):
    """Serializer for user data."""
    
    class Meta:
        model = User
        fields = ("id", "email", "username", "first_name", "last_name", "is_staff")
