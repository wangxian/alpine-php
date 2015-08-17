FROM alpine:latest
MAINTAINER WangXian <xian366@126.com>

ENV HOME=/root

# install packages
RUN apk --update --no-progress add \
        nginx git curl openssl \
        php-fpm php-mcrypt php-curl php-gd php-json php-openssl \
        php-pdo_mysql php-pdo_sqlite php-phar php-iconv \
	&& rm -rf /var/cache/apk/* \
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /app/logs && chown -R nginx /app/logs

ADD conf/nginx.conf /etc/nginx/
ADD conf/php-fpm.conf /etc/php/

ADD services.d/nginx /etc/services.d/nginx/
ADD services.d/php-fpm /etc/services.d/php-fpm/

# install s6 supervisor
ENV S6_VERSION 1.13.0.0
RUN cd /tmp \
    && wget https://github.com/just-containers/s6-overlay/releases/download/v$S6_VERSION/s6-overlay-amd64.tar.gz \
    && tar xzf s6-overlay-amd64.tar.gz -C / \
    && rm -f s6-overlay-amd64.tar.gz

CMD ["/init"]

WORKDIR /app

VOLUME /app

EXPOSE 80
