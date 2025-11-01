"""
Development settings.
"""

from .base import *

# SECURITY WARNING: keep the secret key used in production secret!
SECRET_KEY = 'django-insecure-6^cz+xryodxlw86k+z!qs&bh4knj$&wfa49d2*fb+i7(w-$wks'

# SECURITY WARNING: don't run with debug turned on in production!
DEBUG = True

ALLOWED_HOSTS = ['localhost', '127.0.0.1', '[::1]']


# Database
# https://docs.djangoproject.com/en/5.2/ref/settings/#databases

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR / 'db.sqlite3',
    }
}


# Development-specific settings

# Show detailed error pages
DEBUG_PROPAGATE_EXCEPTIONS = False

# Disable template caching for development
TEMPLATES[0]['OPTIONS']['debug'] = True

# Console email backend for development
EMAIL_BACKEND = 'django.core.mail.backends.console.EmailBackend'

# Allow all internal IPs for debug toolbar if installed
INTERNAL_IPS = [
    '127.0.0.1',
    'localhost',
]

