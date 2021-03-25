FROM php:7.4-apache

# not the best, due laravel permissions on storage on mount from docker-compose. On stateless do redesign
RUN usermod -u 1000 www-data

# CONSUME BUILD ARGS FOR TRACE
ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE 

WORKDIR /var/www/html

RUN apt update && \
    apt install -y git libssl-dev libxml2-dev libpng-dev libc-client-dev libkrb5-dev libpq-dev libzip-dev locales ssl-cert&&  \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
#build locales
RUN   echo " es_AR.UTF-8 UTF-8">> /etc/locale.gen && locale-gen
# install PHP extensions

COPY config/php/php.ini-production /usr/local/etc/php/php.ini

RUN    docker-php-ext-install soap
RUN    docker-php-ext-install mysqli
RUN    docker-php-ext-install pdo_mysql
RUN    docker-php-ext-install bcmath
RUN    docker-php-ext-install gd
RUN    docker-php-ext-install zip

RUN    docker-php-ext-configure imap --with-kerberos --with-imap-ssl &&\
       docker-php-ext-install imap

RUN    docker-php-ext-install  pgsql pdo_pgsql
RUN    pecl install xdebug 

RUN    pecl install mongodb
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

COPY apache2/apache2.conf /etc/apache2/apache2.conf
COPY apache2/sites-enabled/vhost.conf /etc/apache2/sites-available/000-default.conf

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite 
RUN a2enmod ssl
RUN a2ensite default-ssl

