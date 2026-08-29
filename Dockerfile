FROM python:3.12-slim

WORKDIR /app

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        ffmpeg \
        nginx \
        supervisor \
        gettext-base \
    && rm -rf /var/lib/apt/lists/*

COPY requirements.txt .

RUN pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r requirements.txt

COPY . .

RUN test -f /app/config.py || cp /app/config.example.py /app/config.py

COPY render-nginx.conf.template \
    /etc/nginx/templates/render-nginx.conf.template

COPY supervisord.conf \
    /etc/supervisor/conf.d/supervisord.conf

COPY docker-entrypoint.sh \
    /usr/local/bin/docker-entrypoint.sh

RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && rm -f /etc/nginx/sites-enabled/default \
    && rm -f /etc/nginx/conf.d/default.conf

ENV PYTHONUNBUFFERED=1
ENV PORT=10000

EXPOSE 10000

CMD ["/usr/local/bin/docker-entrypoint.sh"]
