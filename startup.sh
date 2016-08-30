#!/bin/sh
# tail -F /app/logs/nginx-access.log /app/logs/nginx-error.log /app/logs/php-fpm-error.log /app/logs/php-fpm-slow.log &
exec php-fpm -F &
exec nginx