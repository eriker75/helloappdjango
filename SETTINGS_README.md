# Django Settings Configuration

This project uses a modular settings structure with separate configurations for development and production environments.

## Structure

```
core/
└── settings/
    ├── __init__.py
    ├── base.py           # Common settings for all environments
    ├── development.py    # Development-specific settings
    └── production.py     # Production-specific settings
```

## How it Works

The application determines which settings file to use based on the `DJANGO_ENV` environment variable:

- **development** (default): Uses `core.settings.development`
- **production**: Uses `core.settings.production`

## Setup Instructions

### 1. Install Dependencies

First, make sure you have `python-dotenv` installed:

```bash
pip install python-dotenv
```

### 2. Create Environment File

Create a `.env` file in the project root (same directory as `manage.py`):

**For Development:**
```env
DJANGO_ENV=development
```

**For Production:**
```env
DJANGO_ENV=production
DJANGO_SECRET_KEY=your-secret-key-here
DJANGO_ALLOWED_HOSTS=example.com,www.example.com
DB_NAME=djangoblog
DB_USER=postgres
DB_PASSWORD=your_db_password
DB_HOST=localhost
DB_PORT=5432
EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_HOST_USER=your_email@gmail.com
EMAIL_HOST_PASSWORD=your_email_password
```

### 3. Generate Secret Key for Production

Run this command to generate a secure secret key:

```bash
python -c 'from django.core.management.utils import get_random_secret_key; print(get_random_secret_key())'
```

## Settings by Environment

### Base Settings (All Environments)

Located in `core/settings/base.py`:
- Installed apps
- Middleware
- Templates configuration
- Password validators
- Internationalization
- Static files configuration

### Development Settings

Located in `core/settings/development.py`:
- `DEBUG = True`
- SQLite database
- Insecure SECRET_KEY (not for production)
- Console email backend
- ALLOWED_HOSTS includes localhost

### Production Settings

Located in `core/settings/production.py`:
- `DEBUG = False`
- PostgreSQL database
- SECRET_KEY from environment variable (required)
- ALLOWED_HOSTS from environment variable (required)
- Security settings (SSL, HSTS, secure cookies)
- SMTP email backend
- Logging configuration
- Static/Media files configuration

## Running the Application

### Development

```bash
# Make sure .env has DJANGO_ENV=development
python manage.py runserver
```

### Production

```bash
# Make sure .env has DJANGO_ENV=production and all required variables
python manage.py collectstatic --noinput
gunicorn core.wsgi:application
```

## Environment Variables Reference

| Variable | Required | Default | Description |
|----------|----------|---------|-------------|
| `DJANGO_ENV` | No | development | Environment: development or production |
| `DJANGO_SECRET_KEY` | Yes (prod) | - | Django secret key for production |
| `DJANGO_ALLOWED_HOSTS` | Yes (prod) | - | Comma-separated list of allowed hosts |
| `DB_NAME` | No | djangoblog | Database name (production) |
| `DB_USER` | No | postgres | Database user (production) |
| `DB_PASSWORD` | Yes (prod) | - | Database password (production) |
| `DB_HOST` | No | localhost | Database host (production) |
| `DB_PORT` | No | 5432 | Database port (production) |
| `EMAIL_HOST` | No | smtp.gmail.com | SMTP host (production) |
| `EMAIL_PORT` | No | 587 | SMTP port (production) |
| `EMAIL_HOST_USER` | No | - | SMTP username (production) |
| `EMAIL_HOST_PASSWORD` | No | - | SMTP password (production) |

## Notes

- The `.env` file should **never** be committed to version control
- Always use environment variables for sensitive data in production
- The development environment uses SQLite for simplicity
- The production environment is configured for PostgreSQL
- All code must be in English, only this documentation can be in Spanish if needed

