FROM python:3.11.8-slim-bookworm

RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get clean
RUN pip install --upgrade pip setuptools
RUN apt-get update && apt-get upgrade -y && apt-get clean

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV DJANGO_SETTINGS_MODULE=downtimedeployment.settings

WORKDIR /app

COPY requirements.txt .
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends gcc && \
    pip install --no-cache-dir -r requirements.txt && \
    apt-get purge -y --auto-remove gcc && \
    rm -rf /var/lib/apt/lists/*

COPY . .

EXPOSE 8001

CMD ["gunicorn", "downtimedeployment.wsgi:application", "--bind", "0.0.0.0:8001"]