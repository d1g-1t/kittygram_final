FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt --no-cache-dir

COPY . .

RUN chmod +x wait-for-db.py

CMD python wait-for-db.py && python manage.py migrate && gunicorn --bind 0.0.0.0:9000 furrymetrics_backend.wsgi