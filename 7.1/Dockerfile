FROM php:7.1-fpm

RUN apt-get update && apt-get install -y wget

ENV DOCKERIZE_VERSION v0.3.0
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

ADD conf/uploads.tmpl /usr/local/etc/php/conf.d/uploads.tmpl

ENTRYPOINT dockerize -template /usr/local/etc/php/conf.d/uploads.tmpl:/usr/local/etc/php/conf.d/uploads.ini
CMD php-fpm