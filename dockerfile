FROM php:5-apache

RUN apt update \
    && apt install -y \
    git libssl-dev libxml2-dev \
    libpng-dev locales ssl-cert \
    libldap2-dev libzip-dev \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb \
    /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin

#build locales
RUN   echo " es_AR.UTF-8 UTF-8">> /etc/locale.gen && locale-gen

RUN docker-php-ext-install soap
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install mysql
RUN docker-php-ext-install pdo_mysql 
RUN docker-php-ext-install gd 
RUN docker-php-ext-configure zip --with-libzip 
RUN docker-php-ext-install zip
RUN docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/
RUN docker-php-ext-install ldap
RUN pecl install mongo

COPY php5/ /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf

RUN rm -f /etc/apt/apt.conf.d/20proxy.conf
RUN a2enmod rewrite
RUN a2enmod ssl
RUN a2ensite default-ssl
