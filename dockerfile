FROM debian:wheezy
COPY 20proxy /etc/apt/apt.conf.d/20proxy
RUN apt-get update \
    && apt-get -y install \
       libapache2-mod-php5 \
       php5-xdebug \
       phpmyadmin \
       git \
       libssl-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
#RUN pecl install xdebug
#RUN pecl install mongo
COPY php5 /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf
COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/
RUN rm -f /etc/apt/apt.conf.d/20proxy
RUN a2enmod rewrite
COPY apache2-foreground /usr/local/bin/
WORKDIR /var/www/html
ENTRYPOINT ["docker-php-entrypoint"]
EXPOSE 80
CMD ["apache2-foreground"]