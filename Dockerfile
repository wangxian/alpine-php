FROM alpine:3.16
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
# VOLUME /app

ENV SWOOLE_VERSION=4.8.12

# install packages
RUN apk add --update curl wget bash \
        openssl libstdc++ openssl-dev php8-dev curl-dev autoconf make pkgconf g++ gcc build-base linux-headers \
        php8-xml php8-xmlreader php8-xmlwriter php8-simplexml php8-mbstring php8-curl php8-gd php8-openssl php8-opcache \
        php8-mysqli php8-pdo_mysql php8-pdo_sqlite php8-phar php8-iconv php8-soap php8-zip php8-sockets php8-session php8-sodium php8-bcmath \
    && ln -sfv /usr/bin/php8 /usr/bin/php && ln -sfv /usr/bin/php-config8 /usr/bin/php-config && ln -sfv /usr/bin/phpize8 /usr/bin/phpize \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && cd /tmp \
    && wget https://github.com/igbinary/igbinary/archive/3.2.7.zip \
    && unzip 3.2.7.zip && cd igbinary-3.2.7 \
    && /usr/bin/phpize8 && ./configure --with-php-config=/usr/bin/php-config8 \
    && make && make install \
    && echo extension=igbinary.so >> /etc/php8/conf.d/01_igbinary.ini \
    && cd /tmp \
    && wget https://github.com/phpredis/phpredis/archive/5.3.7.zip \
    && unzip 5.3.7.zip && cd phpredis-5.3.7 \
    && /usr/bin/phpize8 && ./configure --enable-redis-igbinary --with-php-config=/usr/bin/php-config8 \
    && make && make install \
    && echo extension=redis.so >> /etc/php8/conf.d/01_redis.ini \
    && cd /tmp \
    && wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.zip \
    && unzip v${SWOOLE_VERSION}.zip && cd swoole-src-${SWOOLE_VERSION} \
    && /usr/bin/phpize8 && ./configure --enable-openssl --enable-sockets --enable-mysqlnd --enable-swoole-curl --with-php-config=/usr/bin/php-config8 \
    && make && make install \
    && echo extension=swoole.so >> /etc/php8/conf.d/01_swoole.ini \
    && apk del openssl-dev curl-dev php8-dev autoconf make pkgconf g++ gcc build-base \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && php -m && php --ri swoole


# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy app source to image
ADD . .

ADD docker/php.ini /etc/php8/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
