#!/bin/sh
set -eu

PORT="${PORT:-10000}"

export PORT

envsubst '${PORT}' \
    < /etc/nginx/templates/render-nginx.conf.template \
    > /etc/nginx/conf.d/default.conf

nginx -t

exec /usr/bin/supervisord \
    -c /etc/supervisor
