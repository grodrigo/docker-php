FROM php:5-apache
# APT proxy for faster install uses apt-cacher-ng instance
COPY config/apt.conf /etc/apt/

RUN apt update && \
apt install -y git libssl-dev libxml2-dev && \
rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install soap
RUN pecl install xdebug
RUN pecl install mongo
COPY php5 /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf

RUN rm -rf /etc/apt/apt.conf
RUN a2enmod rewrite && apache2ctl restart