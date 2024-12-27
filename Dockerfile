FROM alpine:3.16
LABEL maintainer="WangXian <xian366@126.com>"

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update nginx curl openssl wget bash \
        php81-fpm php81-mbstring php81-curl php81-gd php81-openssl php81-opcache \
        php81-xml php81-xmlreader php81-xmlwriter php81-simplexml \
        php81-mysqli php81-session php81-pdo_mysql php81-pdo_sqlite php81-phar php81-iconv php81-soap php81-zip \
        php81-pecl-redis \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && ln -sfv /usr/bin/php81 /usr/bin/php \
    && ln -sfv /usr/bin/php81 /usr/bin/php8 \
    && ln -sfv /etc/php81 /etc/php \
    && ln -sfv /etc/php81 /etc/php8 \
    && ln -sfv /usr/sbin/php-fpm81 /usr/sbin/php-fpm \
    && ln -sfv /usr/sbin/php-fpm81 /usr/sbin/php-fpm8 \
    && rm -rfv /var/cache/apk/* \
    && php -m

# copy source to image
ADD . .
RUN rm -rf /app/.git && mv /app/docker/startup.sh /app

ADD docker/nginx.conf /etc/nginx/
ADD docker/php-fpm.conf /etc/php8/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
