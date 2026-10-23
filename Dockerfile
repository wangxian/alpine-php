FROM alpine:3.22
LABEL maintainer="WangXian <xian366@126.com>"

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update nginx curl openssl wget bash \
        php85-fpm php85-mbstring php85-curl php85-gd php85-openssl \
        php85-xml php85-xmlreader php85-xmlwriter php85-simplexml \
        php85-mysqli php85-session php85-pdo_mysql php85-pdo_sqlite php85-phar php85-iconv php85-soap php85-zip \
        php85-pecl-redis \
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \
    && ln -sfv /usr/bin/php85 /usr/bin/php \
    && ln -sfv /usr/bin/php85 /usr/bin/php8 \
    && ln -sfv /etc/php85 /etc/php \
    && ln -sfv /etc/php85 /etc/php8 \
    && ln -sfv /usr/sbin/php-fpm85 /usr/sbin/php-fpm \
    && ln -sfv /usr/sbin/php-fpm85 /usr/sbin/php-fpm8 \
    && rm -rfv /var/cache/apk/* \
    && php -m

# copy source to image
ADD . .
RUN rm -rf /app/.git && mv /app/docker/startup.sh /app

ADD docker/nginx.conf /etc/nginx/
ADD docker/php-fpm.conf /etc/php8/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
