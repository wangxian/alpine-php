FROM alpine:latest
MAINTAINER WangXian <xian366@126.com>

ENV HOME=/root

# install packages
RUN apk --update --no-progress add \
        nginx git curl openssl \
        php-fpm php-mcrypt php-curl php-gd php-json php-openssl \
        php-mysql php-mysqli php-pdo_mysql php-pdo_sqlite php-phar php-iconv \
	&& rm -rf /var/cache/apk/* \
	&& curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN mkdir -p /app/logs && chown -R nginx /app/logs

# copy app source to image
ADD . .

ADD conf/nginx.conf /etc/nginx/
ADD conf/php-fpm.conf /etc/php/
ADD startup.sh /startup.sh

WORKDIR /app
VOLUME /app

EXPOSE 80 443
CMD ["/startup.sh"]

