FROM alpine:3.22
LABEL maintainer="WangXian <xian366@126.com>"

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update nginx curl openssl wget bash \
        php82-fpm php82-mbstring php82-curl php82-gd php82-openssl php82-opcache \
        php82-xml php82-xmlreader php82-xmlwriter php82-simplexml \
        php82-mysqli php82-session php82-pdo_mysql php82-pdo_sqlite php82-phar php82-iconv php82-soap php82-zip \
        php82-pecl-redis \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && ln -sfv /usr/bin/php82 /usr/bin/php \
    && ln -sfv /usr/bin/php82 /usr/bin/php8 \
    && ln -sfv /etc/php82 /etc/php \
    && ln -sfv /etc/php82 /etc/php8 \
    && ln -sfv /usr/sbin/php-fpm82 /usr/sbin/php-fpm \
    && ln -sfv /usr/sbin/php-fpm82 /usr/sbin/php-fpm8 \
    && rm -rfv /var/cache/apk/* \
    && php -m

# copy source to image
ADD . .
RUN rm -rf /app/.git && mv /app/docker/startup.sh /app

ADD docker/nginx.conf /etc/nginx/
ADD docker/php-fpm.conf /etc/php8/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
