# Dockerfile for HelloApp-Django
FROM python:3.13-bullseye

# Ensure logs are sent straight to the terminal (no buffering)
ENV PYTHONDONTWRITEBYTECODE=1

# Prevent Python from writing .pyc files to disk (not needed in containers)
ENV PYTHONUNBUFFERED=1

# Install system dependencies for mysqlclient and general builds
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    default-libmysqlclient-dev \
    && rm -rf /var/lib/apt/lists/*

# Set work directory
WORKDIR /app

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy project files (including manage.py, apps, etc.)
COPY . .

# Copy and make /start.sh script executable
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port 8000 for Django dev server
EXPOSE 8000