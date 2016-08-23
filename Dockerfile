FROM alpine:latest
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
VOLUME /app

RUN echo "ipv6" >> /etc/modules
RUN echo "http://dl-5.alpinelinux.org/alpine/v3.3/main/" > /etc/apk/repositories
RUN echo "http://dl-6.alpinelinux.org/alpine/v3.3/main/" >> /etc/apk/repositories

# install packages
RUN apk add --no-cache nginx curl openssl \
        php-fpm php-mcrypt php-curl php-gd php-json php-openssl \
        php-mysql php-mysqli php-pdo_mysql php-pdo_sqlite php-phar php-iconv php-soap php-zip

# Install testing php-redis
RUN apk add php-redis --update-cache --repository http://dl-5.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && php -m

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata
RUN rm /var/cache/apk/*

RUN mkdir -p /app/logs && chown -R nginx /app/logs

# Copy app source to image
ADD . .

ADD conf/nginx.conf /etc/nginx/
ADD conf/php-fpm.conf /etc/php/

EXPOSE 80 443
CMD ["./startup.sh"]
