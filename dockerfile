FROM php:7-apache-stretch
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE 
# APT proxy for faster install uses apt-cacher-ng instance
COPY config/20proxy.conf /etc/apt/apt.conf.d/

RUN apt update && \
    apt install -y git libssl-dev libxml2-dev libpng-dev libc-client-dev libkrb5-dev libpq-dev libzip-dev locales&& \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
#build locales
RUN   echo " es_AR.UTF-8 UTF-8">> /etc/locale.gen && locale-gen
# install PHP extensions
RUN    docker-php-ext-install soap
RUN    docker-php-ext-install mysqli
RUN    docker-php-ext-install pdo_mysql
RUN    docker-php-ext-install bcmath
RUN    docker-php-ext-install gd
RUN    docker-php-ext-configure zip --with-libzip  &&\
       docker-php-ext-install zip

RUN    docker-php-ext-configure imap --with-kerberos --with-imap-ssl &&\
       docker-php-ext-install imap

RUN    docker-php-ext-install  pgsql pdo_pgsql
RUN    pecl install xdebug 
RUN    pecl install mongodb

COPY config/php /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf

RUN rm -f /etc/apt/apt.conf.d/20proxy.conf
RUN a2enmod rewrite 
