FROM php:5-apache
COPY 20proxy /etc/apt/apt.conf.d/20proxy
RUN apt-get update && apt-get -y install \
       git \
       libssl-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
RUN pecl install xdebug
RUN pecl install mongo
COPY php5 /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf
RUN docker-php-ext-install mysqli
RUN rm -f /etc/apt/apt.conf.d/20proxy
RUN a2enmod rewrite
