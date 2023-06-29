#!/bin/sh

exec php-fpm8 -F &
exec nginx
