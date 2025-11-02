from typing import Any, cast
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework.request import Request
from rest_framework import status, permissions
from django.contrib.auth import authenticate
from rest_framework_simplejwt.tokens import RefreshToken
from django.db import IntegrityError
from .serializers import RegisterSerializer, UserSerializer
from .models import User


class RegisterView(APIView):
    """
    API endpoint for user registration.

    Handles user creation and returns JWT tokens upon successful registration.
    """

    def post(self, request: Request) -> Response:
        """
        Create a new user account.

        Args:
            request: HTTP request containing user data (email, username, password, password_confirmation)

        Returns:
            Response with access token, refresh token and user data on success (201)
            Response with validation errors on failure (400)
        """
        serializer = RegisterSerializer(data=request.data)

        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Create user - no need to authenticate, we just created them
            user = cast(User, serializer.save())

            # Generate JWT tokens for the new user
            refresh = RefreshToken.for_user(user)

            return Response(
                {
                    "access": str(refresh.access_token),
                    "refresh": str(refresh),
                    "user": UserSerializer(user).data,
                },
                status=status.HTTP_201_CREATED,
            )

        except IntegrityError as e:
            return Response(
                {"detail": "User with this email or username already exists."},
                status=status.HTTP_400_BAD_REQUEST,
            )
        except Exception as e:
            return Response(
                {"detail": "An error occurred during registration. Please try again."},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


class LoginView(APIView):
    """
    API endpoint for user authentication.

    Handles user login and returns JWT tokens upon successful authentication.
    """

    def post(self, request: Request) -> Response:
        """
        Authenticate user and generate tokens.

        Args:
            request: HTTP request containing email and password

        Returns:
            Response with access token, refresh token and user data on success (200)
            Response with error message on failure (400/401)
        """
        # Get credentials from request data
        data = cast(dict[str, Any], request.data)
        email = data.get("email")
        password = data.get("password")

        # Validate required fields
        if not email or not password:
            return Response(
                {"detail": "Email and password are required."},
                status=status.HTTP_400_BAD_REQUEST,
            )

        # Authenticate user (using email as USERNAME_FIELD)
        authenticated_user = authenticate(username=email, password=password)

        if not authenticated_user:
            return Response(
                {"detail": "Invalid credentials."},
                status=status.HTTP_401_UNAUTHORIZED,
            )

        # Cast to User type after None check
        user = cast(User, authenticated_user)

        if not user.is_active:
            return Response(
                {"detail": "User account is disabled."},
                status=status.HTTP_401_UNAUTHORIZED,
            )

        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)

        return Response(
            {
                "access": str(refresh.access_token),
                "refresh": str(refresh),
                "user": UserSerializer(user).data,
            },
            status=status.HTTP_200_OK,
        )


class ProfileView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def get(self, request: Request) -> Response:
        return Response(UserSerializer(request.user).data)


class LogoutView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request) -> Response:
        try:
            refresh_token = request.data["refresh"]
            token = RefreshToken(refresh_token)
            token.blacklist()
            return Response(
                {"detail": "Logout exitoso"}, status=status.HTTP_205_RESET_CONTENT
            )
        except Exception:
            return Response(
                {"detail": "Token inválido"}, status=status.HTTP_400_BAD_REQUEST
            )
