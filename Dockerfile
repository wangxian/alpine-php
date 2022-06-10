FROM registry.cn-beijing.aliyuncs.com/wboll/alpine:3.9
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
# VOLUME /app

ENV SWOOLE_VERSION=4.6.1

# install packages
RUN apk add --update nginx curl openssl wget bash \
        php7-fpm php7-mcrypt php7-mbstring php7-curl php7-gd php7-json php7-openssl php7-opcache \
        php7-xml php7-xmlreader php7-xmlwriter php7-simplexml \
        php7-mysqli php7-session php7-pdo_mysql php7-pdo_sqlite php7-phar php7-iconv php7-soap php7-zip \
        php7-pecl-redis \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && apk add --no-cache --virtual .build-deps openssl-dev curl-dev php7-dev autoconf make pkgconf g++ gcc build-base \
    && cd /tmp \
    && wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.zip \
    && unzip v${SWOOLE_VERSION}.zip && cd swoole-src-${SWOOLE_VERSION} \
    && /usr/bin/phpize7 && ./configure \
        --enable-openssl \
        --enable-sockets \
        --enable-mysqlnd \
        --enable-swoole-curl \
        --with-php-config=/usr/bin/php-config7 \
    && make && make install \
    && echo extension=swoole.so >> /etc/php7/conf.d/01_swoole.ini \
    && apk del .build-deps \
    && ln -sfv /usr/bin/php7 /usr/bin/php \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && php -m && php --ri swoole

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy app source to image
ADD . .

ADD docker/php.ini /etc/php7/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
