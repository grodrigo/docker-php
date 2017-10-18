FROM php:7-apache
RUN apt update
RUN apt install -y git libssl-dev
RUN pecl install xdebug
RUN pecl install mongodb
RUN docker-php-ext-install bcmath 
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install zip
COPY php /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf
RUN a2enmod rewrite 