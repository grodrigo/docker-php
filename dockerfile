FROM php:5-apache
# APT proxy for faster install uses apt-cacher-ng instance
COPY config/20proxy.conf /etc/apt/apt.conf.d/

RUN apt update && \
apt install -y git libssl-dev libxml2-dev && \
 rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

RUN docker-php-ext-install soap &&\
    docker-php-ext-install mysqli &&\
    docker-php-ext-install mysql &&\
    docker-php-ext-install pdo_mysql  &&\
    pecl install xdebug &&\
    pecl install mongo

COPY php5/ /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf

RUN rm -f /etc/apt/apt.conf.d/20proxy.conf
RUN a2enmod rewrite
