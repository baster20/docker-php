FROM php:7.1-fpm

VOLUME /var/www/html

# Install "curl", "libmemcached-dev", "libpq-dev", "libjpeg-dev",
#         "libpng12-dev", "libfreetype6-dev", "libssl-dev", "libmcrypt-dev",
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    curl \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng12-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    gettext-base \
    git \
    sudo \
  && rm -rf /var/lib/apt/lists/*

# Set the PHP redis version
ENV PHPREDIS_VERSION 3.1.4

# Install the PHP mcrypt extention
RUN docker-php-ext-install mcrypt \
  # Install the PHP mysqli extention
  && docker-php-ext-install mysqli \
  # Install the PHP pdo_mysql extention
  && docker-php-ext-install pdo_mysql \
  # Install the PHP pdo_pgsql extention
  && docker-php-ext-install pdo_pgsql \
  # Install the PHP gd library
  && docker-php-ext-configure gd \
    --enable-gd-native-ttf \
    --with-jpeg-dir=/usr/lib \
    --with-freetype-dir=/usr/include/freetype2 \
  && docker-php-ext-install gd \
  # Install the PHP bcmath extention
  && docker-php-ext-install bcmath \
  # Install the PHP zip extention
  && docker-php-ext-install zip \
  # Install the PHP mongo extention
  && pecl install mongodb \
  && docker-php-ext-enable mongodb

## Install the PHP redis extension
RUN curl -L -o redis.tar.gz https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz \
  && tar xfz redis.tar.gz \
  && rm -r redis.tar.gz \
  && ( \
        cd phpredis-$PHPREDIS_VERSION \
        && phpize \
        && ./configure \
        && make \
        && make install \
    ) \
  && rm -r phpredis-$PHPREDIS_VERSION \
  && docker-php-ext-enable redis

# Setup the Composer
RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
  && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
  && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }" \
  && php /tmp/composer-setup.php \
  && php -r "unlink('/tmp/composer-setup.php');" \
  && mv composer.phar /usr/local/bin/composer

ADD ./templates/uploads.tmpl /opt/uploads.tmpl
ADD ./scripts/entrypoint.sh /usr/bin/entrypoint

ENTRYPOINT ["entrypoint"]
CMD ["php-fpm"]
