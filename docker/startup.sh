#!/bin/sh

exec php-fpm7 -F &
exec nginx
