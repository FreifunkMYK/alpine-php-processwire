FROM alpine:edge
MAINTAINER Etopian Inc. <contact@etopian.com>

LABEL devoply.type="site"
LABEL devoply.cms="wordpress"
LABEL devoply.framework="wordpress"
LABEL devoply.language="php"
LABEL devoply.require="mariadb etopian/nginx-proxy"
LABEL devoply.recommend="redis"
LABEL devoply.description="WordPress on Nginx and PHP-FPM with WP-CLI."
LABEL devoply.name="WordPress"

RUN apk update \
    && apk add bash less vim nginx ca-certificates \
    php-fpm php-json php-zlib php-xml php-pdo php-phar php-openssl \
    php-pdo_mysql php-mysqli \
    php-gd php-iconv php-mcrypt \
    php-mysql php-curl php-opcache php-ctype php-apcu \
    php-intl php-bcmath php-dom php-xmlreader mysql-client && apk add -u musl

RUN rm -rf /var/cache/apk/*

ENV TERM="xterm" 
ENV DB_HOST="172.17.42.1"
ENV DB_NAME=""
ENV DB_USER=""
ENV DB_PASS=""
RUN sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php5/fpm/php.ini
ADD files/nginx.conf /etc/nginx/
ADD files/php-fpm.conf /etc/php/
ADD files/run.sh /
RUN chmod +x /run.sh

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/bin/wp-cli

EXPOSE 80
VOLUME ["/DATA"]

CMD ["/run.sh"]
