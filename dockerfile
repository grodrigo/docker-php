FROM php:7.4-apache
# CONSUME BUILD ARGS FOR TRACE
ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.build-date=$BUILD_DATE 

RUN apt update && \
    apt install -y git libssl-dev libxml2-dev libpng-dev libc-client-dev libkrb5-dev libpq-dev libzip-dev locales ssl-cert&&  \
    rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
#build locales
RUN   echo " es_AR.UTF-8 UTF-8">> /etc/locale.gen && locale-gen
# install PHP extensions
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

COPY config/php/php.ini-production /usr/local/etc/php/php.ini
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini

COPY apache2/apache2.conf /etc/apache2/apache2.conf

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite 
RUN a2enmod ssl
RUN a2ensite default-ssl

