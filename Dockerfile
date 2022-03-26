FROM alpine:3.9
MAINTAINER WangXian <xian366@126.com>

WORKDIR /app
# VOLUME /app

# install packages
RUN apk add --update nginx curl openssl wget bash \
        php7-fpm php7-mcrypt php7-mbstring php7-curl php7-gd php7-json php7-openssl php7-opcache \
        php7-xml php7-xmlreader php7-xmlwriter php7-simplexml \
        php7-mysqli php7-session php7-pdo_mysql php7-pdo_sqlite php7-phar php7-iconv php7-soap php7-zip \
        php7-pecl-redis \

    # fix CN timezone
    && apk add tzdata && cp /usr/share/zoneinfo/PRC /etc/localtime && echo "PRC" > /etc/timezone && apk del tzdata \

    && ln -sfv /usr/bin/php7 /usr/bin/php \
    && rm -rfv /var/cache/apk/* \

    && php -m

# copy source to image
ADD . .
RUN rm -rf /app/.git && mv /app/docker/startup.sh /app

ADD docker/nginx.conf /etc/nginx/
ADD docker/php-fpm.conf /etc/php7/

EXPOSE 80 443
CMD ["/bin/sh", "/app/startup.sh"]
