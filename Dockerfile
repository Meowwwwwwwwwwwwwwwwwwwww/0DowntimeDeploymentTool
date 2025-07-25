FROM python:3.11.8-slim-bookworm

# Ensure all system packages are up-to-date and security patches are applied
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y && apt-get clean

# Upgrade pip and setuptools to latest versions to mitigate known vulnerabilities
RUN pip install --upgrade pip setuptools

# Ensure all system packages are up-to-date 
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

EXPOSE 8000

CMD ["gunicorn", "downtimedeployment.wsgi:application", "--bind", "0.0.0.0:8000"]
