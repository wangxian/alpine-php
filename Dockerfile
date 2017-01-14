FROM alpine:3.5
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update nginx curl openssl \
        php7-fpm php7-mcrypt php7-curl php7-gd php7-json php7-openssl php7-opcache \
        php7-mysqli php7-pdo_mysql php7-pdo_sqlite php7-phar php7-iconv php7-soap php7-zip

# Install testing php7-redis
RUN apk add php7-redis --update-cache --repository http://dl-5.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && php -m

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata
RUN rm /var/cache/apk/*

# Copy app source to image
ADD . .

ADD docker/nginx.conf /etc/nginx/
ADD docker/php-fpm.conf /etc/php7/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
