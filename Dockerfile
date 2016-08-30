FROM alpine:3.4
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update nginx curl openssl \
        php5-fpm php5-mcrypt php5-curl php5-gd php5-json php5-openssl \
        php5-mysql php5-mysqli php5-pdo_mysql php5-pdo_sqlite php5-phar php5-iconv php5-soap php5-zip

# Install testing php5-redis
RUN apk add php5-redis --update-cache --repository http://dl-5.alpinelinux.org/alpine/edge/testing/ --allow-untrusted && php -m

# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata
# RUN rm /var/cache/apk/*

RUN mkdir -p /app/logs && chown -R nginx /app/logs

# Copy app source to image
ADD . .

ADD conf/nginx.conf /etc/nginx/
ADD conf/php-fpm.conf /etc/php5/

EXPOSE 80 443
CMD ["./startup.sh"]
