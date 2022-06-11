FROM phpswoole/swoole:4.6.7-php7.2-alpine
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update --no-cache --virtual .build-deps $PHPIZE_DEPS curl-dev openssl-dev pcre-dev pcre2-dev zlib-dev \
        libpng-dev freetype-dev libjpeg-turbo-dev libwebp-dev libxml2-dev \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && pecl install igbinary-3.2.7 && docker-php-ext-enable igbinary \
    && pecl install redis-5.3.2 --enable-redis-igbinary && docker-php-ext-enable redis \
    && docker-php-ext-install gd mysqli pdo_mysql soap zip \
    && rm -rf /usr/bin/composer /root/.composer \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && docker-php-source delete \
    && apk del .build-deps \
    && php -m && php --ri swoole

# copy source to image
ADD . .
RUN rm -rf /app/.git && mv /app/docker/startup.sh /app

ADD docker/php.ini /usr/local/etc/php/php.ini

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
