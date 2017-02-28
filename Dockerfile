FROM alpine:3.5
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update curl openssl \
        php7-mcrypt php7-mbstring php7-curl php7-gd php7-json php7-openssl php7-opcache \
        php7-mysqli php7-pdo_mysql php7-pdo_sqlite php7-phar php7-iconv php7-soap php7-zip \
        php7-sockets php7-dev autoconf make pkgconf g++ gcc openssl-dev build-base linux-headers

# Link php7 to php
RUN ln -sfv /usr/bin/php7 /usr/bin/php

# Install testing php7-redis
RUN apk add php7-redis --update-cache --repository http://dl-5.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && php7 -m

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata
RUN rm /var/cache/apk/*

RUN cd /tmp && wget https://github.com/swoole/swoole-src/archive/v2.0.6.zip \
      && unzip v2.0.6.zip && cd swoole-src-2.0.6 \
      && /usr/bin/phpize7 && ./configure --enable-openssl --enable-sockets --enable-coroutine --with-php-config=/usr/bin/php-config7 \
      && make && make install

RUN echo extension=swoole.so >> /etc/php7/conf.d/01_swoole.ini
RUN rm -rfv /tmp/*
RUN apk del php7-dev autoconf make pkgconf g++ gcc build-base


# Copy app source to image
ADD . .

ADD docker/php.ini /etc/php7/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
