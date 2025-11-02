import uuid
from datetime import date
from typing import Any
from django.db import models
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager


class UserManager(BaseUserManager["User"]):
    """Custom manager for User model."""
    
    def create_user(
        self, 
        email: str, 
        username: str, 
        password: str | None = None, 
        **extra_fields: Any
    ) -> "User":
        """
        Create and save a regular user with the given email, username and password.
        """
        if not email:
            raise ValueError("The Email field is required")
        email = self.normalize_email(email)
        user = self.model(email=email, username=username, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(
        self, 
        email: str, 
        username: str, 
        password: str | None = None, 
        **extra_fields: Any
    ) -> "User":
        """
        Create and save a superuser with the given email, username and password.
        """
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, username, password, **extra_fields)

class User(AbstractBaseUser, PermissionsMixin):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    email = models.EmailField(unique=True)
    username = models.CharField(max_length=150, unique=True)
    first_name = models.CharField(max_length=150, blank=True)
    last_name = models.CharField(max_length=150, blank=True)
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(auto_now_add=True)
    birth_date = models.DateField(null=True, blank=True)

    objects: UserManager = UserManager()  # type: ignore[assignment]

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username']

    def __str__(self) -> str:
        return self.email

    @property
    def age(self) -> int | None:
        """
        Calculate user's age based on birth_date.
        Returns None if birth_date is not set.
        """
        if not self.birth_date:
            return None
        
        today = date.today()
        age = today.year - self.birth_date.year
        
        # Check if birthday hasn't occurred this year yet
        if (today.month, today.day) < (self.birth_date.month, self.birth_date.day):
            age -= 1
        
        return age
