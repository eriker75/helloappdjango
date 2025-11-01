#!/bin/bash
set -o errexit
set -o pipefail
set -o nounset

# Wait for PostgreSQL readiness using Python
echo "==> Waiting for PostgreSQL to be ready..."
python <<EOF
import os, time, sys
import psycopg2
from psycopg2 import OperationalError

host = os.getenv('DB_HOST', 'postgres')
user = os.getenv('DB_USER', 'pawify')
pw = os.getenv('DB_PASSWORD', 'pawifypass')
db = os.getenv('DB_NAME', 'pawify')
port = int(os.getenv('DB_PORT', '5432'))
timeout = int(os.getenv('DB_HEALTH_TIMEOUT', '180'))
start = time.time()

while True:
    try:
        conn = psycopg2.connect(
            host=host, 
            user=user, 
            password=pw, 
            database=db, 
            port=port
        )
        conn.close()
        print("✓ Successfully connected to PostgreSQL.")
        break
    except OperationalError as e:
        if time.time() - start > timeout:
            print(f"!! Timeout waiting for PostgreSQL after {timeout} seconds: {e}")
            sys.exit(1)
        print(f"  Waiting for PostgreSQL ({e}), retrying in 2s...")
        time.sleep(2)
EOF

echo "==> Running Django migrations..."
python manage.py makemigrations --no-input
python manage.py migrate --no-input

echo "==> Collecting static files..."
python manage.py collectstatic --no-input

echo "==> Starting Django development server..."
exec python manage.py runserver 0.0.0.0:8000