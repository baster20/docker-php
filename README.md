# docker-php
Php docker image for CloudEstuary.com

This image based on official php image.

# Composer
This image includes composer.

On start of php-fpm image will install or update composer dependencies,

# Git 
This image can clone or pull (if .git presented) from remote repo

# Additional supported variables
`MAX_UPLOAD_FILE_SIZE`: adjust max post and upload sizes.
`GIT SOURCE`: on container start this repo will be cloned (optional).
`GIT_BRANCH`: optional branch (master by default).
`SSH_KEY`: base64 encoded ssh key for access to private repo (optional).

# Whats included

- curl
- mcrypt
- mysqli
- pdo_mysql
- pdo_pgsql 
- gd 
- redis 
- bcmath
- zip
- mongodb

# docker-compose example

~~~
app:
    image: 'cloudestuary/php-fpm:7.1'
    environment:
        MAX_UPLOAD_FILE_SIZE: 100m
        APP_KEY: base64:2X9U1HiBdmfbwvZ4UkwUP/25svg7439HXKWL1F8Xn1c=
        APP_ENV: local
        GIT_SOURCE: 'https://github.com/laravel/laravel'
    networks:
        - app
    volumes:
        - './:/var/www/html'
worker:
    image: 'cloudestuary/php-cli:7.1'
    environment:
        APP_KEY: base64:2X9U1HiBdmfbwvZ4UkwUP/25svg7439HXKWL1F8Xn1c=
        APP_ENV: local
    networks:
        - app
    volumes:
        - './:/var/www/html'
    command: php artisan queue:work
~~~
