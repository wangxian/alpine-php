FROM alpine:3.16
LABEL maintainer="WangXian <xian366@126.com>"

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update nginx curl openssl wget bash \
        php8-fpm php8-mbstring php8-curl php8-gd php8-openssl php8-opcache \
        php8-xml php8-xmlreader php8-xmlwriter php8-simplexml \
        php8-mysqli php8-session php8-pdo_mysql php8-pdo_sqlite php8-phar php8-iconv php8-soap php8-zip \
        php8-pecl-redis \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && ln -sfv /usr/bin/php8 /usr/bin/php \
    && rm -rfv /var/cache/apk/* \
    && php -m

# copy source to image
ADD . .
RUN rm -rf /app/.git && mv /app/docker/startup.sh /app

ADD docker/nginx.conf /etc/nginx/
ADD docker/php-fpm.conf /etc/php8/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
