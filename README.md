# docker-php
Php docker image for CloudEstuary.com

This image based on official php image.

# Additional supported variables

`MAX_UPLOAD_FILE_SIZE`: adjust max post and upload sizes.

# docker-compose example

~~~
app:
        image: 'cloudestuary/php-fpm:7.1'
        environment:
            MAX_UPLOAD_FILE_SIZE: 100m
        networks:
            - app
        volumes:
            - './:/var/www/html'
worker:
        image: 'cloudestuary/php-cli:7.1'
        networks:
            - app
        volumes:
            - './:/var/www/html'
        command: php artisan queue:work
~~~
