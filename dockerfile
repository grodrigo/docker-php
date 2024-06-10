FROM php:5.6-apache

ENV TZ="America/Argentina/Buenos_Aires"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN echo "deb http://archive.debian.org/debian stretch main" > /etc/apt/sources.list

RUN apt update && apt upgrade -y && \
    apt install libldap2-dev -y && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap &&\
    docker-php-ext-install mysqli &&\
    docker-php-ext-install mysql &&\
    docker-php-ext-install pdo_mysql

RUN a2enmod rewrite

RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
#  && \
#     sed -i "s/short_open_tag = .*/short_open_tag = On/" "$PHP_INI_DIR/php.ini" && \
#     sed -i "s/;session.save_path = .*/session.save_path = '\/var\/php\/sessions'/" "$PHP_INI_DIR/php.ini"

WORKDIR /var/www/html
# COPY --chown=www-data:www-data www /var/www/html
# COPY --chown=www-data:www-data . /var/www/html