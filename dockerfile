FROM php:7.4.33-apache-bullseye

# not the best, due laravel permissions on storage on mount from docker-compose. On stateless do redesign
RUN usermod -u 1000 www-data

# CONSUME BUILD ARGS FOR TRACE
ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.vcs-ref=$VCS_REF \
  org.label-schema.build-date=$BUILD_DATE 

WORKDIR /var/www/html

RUN apt update && \
  apt install -y git libssl-dev libxml2-dev libpng-dev libc-client-dev libkrb5-dev libpq-dev libzip-dev locales ssl-cert p7zip-full libcurl4-openssl-dev libldap2-dev &&  \
  rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
#build locales
RUN   echo " es_AR.UTF-8 UTF-8">> /etc/locale.gen && locale-gen
# install PHP extensions

COPY config/php/php.ini-production /usr/local/etc/php/php.ini

RUN  docker-php-ext-install soap mysqli pdo_mysql bcmath gd zip curl pcntl

RUN  docker-php-ext-configure imap --with-kerberos --with-imap-ssl &&\
  docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ &&\
  docker-php-ext-install imap ldap pgsql pdo_pgsql

# Instalar las extensiones mongodb y xdebug sin interacción
RUN pecl install -n mongodb-1.20.1 && \
  pecl install -n xdebug-3.1.5

# Habilitar las extensiones
RUN echo "extension=mongodb.so" >> /usr/local/etc/php/conf.d/mongodb.ini && \
  echo "zend_extension=xdebug.so" >> /usr/local/etc/php/conf.d/xdebug.ini


COPY apache2/apache2.conf /etc/apache2/apache2.conf
COPY apache2/sites-enabled/vhost.conf /etc/apache2/sites-enabled/000-default.conf

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN a2enmod rewrite 
# RUN a2enmod ssl
# RUN a2ensite default-ssl

RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'upload_max_filesize = 50M' >> /usr/local/etc/php/conf.d/docker-php-uploadmax.ini  && \
  echo 'post_max_size = 50M' >> /usr/local/etc/php/conf.d/docker-php-uploadmax.ini;

# RUN cd /usr/local/etc/php/conf.d/ && \
#   echo 'memory_limit = 2048M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini  && \
#   echo 'max_execution_time = 3600' >> /usr/local/etc/php/conf.d/docker-php-maxexectime.ini;
# # para interfaz + max_execution_time

RUN sed -i 's/CipherString = DEFAULT@SECLEVEL=2/CipherString = DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf
