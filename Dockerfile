FROM registry.cn-beijing.aliyuncs.com/wboll/alpine:3.16
MAINTAINER WangXian <xian366@126.com>

# alpine:3.16   8.0.20
# alpine:3.15   7.4.29
# alpine:3.12   7.3.33
# alpine:3.9    7.2.33

WORKDIR /app
# VOLUME /app

ENV SWOOLE_VERSION=4.8.10

# install packages
RUN apk add --update curl wget bash \
        openssl libstdc++ openssl-dev php7-dev curl-dev autoconf make pkgconf g++ gcc build-base linux-headers \
        php7-xml php7-xmlreader php7-xmlwriter php7-simplexml php7-mbstring php7-curl php7-gd php7-json php7-openssl php7-opcache \
        php7-mysqli php7-pdo_mysql php7-pdo_sqlite php7-phar php7-iconv php7-soap php7-zip php7-sockets php7-session php7-sodium php7-bcmath \
    && ln -sfv /usr/bin/php7 /usr/bin/php && ln -sfv /usr/bin/php-config7 /usr/bin/php-config && ln -sfv /usr/bin/phpize7 /usr/bin/phpize \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && cd /tmp \
    && wget https://github.com/igbinary/igbinary/archive/3.1.2.zip \
    && unzip 3.1.2.zip && cd igbinary-3.1.2 \
    && /usr/bin/phpize7 && ./configure --with-php-config=/usr/bin/php-config7 \
    && make && make install \
    && echo extension=igbinary.so >> /etc/php7/conf.d/01_igbinary.ini \
    && cd /tmp \
    && wget https://github.com/phpredis/phpredis/archive/5.3.1.zip \
    && unzip 5.3.1.zip && cd phpredis-5.3.1 \
    && /usr/bin/phpize7 && ./configure --enable-redis-igbinary --with-php-config=/usr/bin/php-config7 \
    && make && make install \
    && echo extension=redis.so >> /etc/php7/conf.d/01_redis.ini \
    && cd /tmp \
    && wget https://github.com/swoole/swoole-src/archive/v${SWOOLE_VERSION}.zip \
    && unzip v${SWOOLE_VERSION}.zip && cd swoole-src-${SWOOLE_VERSION} \
    && /usr/bin/phpize7 && ./configure --enable-openssl --enable-sockets --enable-mysqlnd --enable-swoole-curl --with-php-config=/usr/bin/php-config7 \
    && make && make install \
    && echo extension=swoole.so >> /etc/php7/conf.d/01_swoole.ini \
    && apk del openssl-dev curl-dev php7-dev autoconf make pkgconf g++ gcc build-base \
    && rm -rf /var/cache/apk/* /tmp/* /usr/share/man \
    && php -m && php --ri swoole


# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy app source to image
ADD . .

ADD docker/php.ini /etc/php7/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
