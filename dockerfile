FROM php:5-apache
RUN apt update
RUN apt install -y git libssl-dev
RUN pecl install xdebug
RUN pecl install mongo
COPY php5 /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf
RUN a2enmod rewrite && apache2ctl restart