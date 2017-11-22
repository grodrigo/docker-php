FROM ubuntu:12.04

#COPY config/apt /etc/
COPY 20proxy /etc/apt/apt.conf.d/20proxy

RUN apt-get update \
    && apt-get -y install \
      apache2 \
      php5 \
      php5-cli \
      libapache2-mod-php5 \
      php5-mysql \
      php5-mysql \
      php5-xdebug \
      curl \
      lynx \
      git \
      libssl-dev \
    && rm -rf /var/lib/apt/lists/* /var/cache/apt/archives/*.deb /var/cache/apt/archives/partial/*.deb /var/cache/apt/*.bin
#RUN pecl install xdebug
#RUN pecl install mongo

### Uncomment to build with custom configs
#COPY php5 /usr/local/etc/php
#COPY apache2/apache2.conf /etc/apache2/apache2.conf

## Entrypoint and apache foreground
COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/
RUN rm -f /etc/apt/apt.conf.d/20proxy
RUN a2enmod rewrite
COPY apache2-foreground /usr/local/bin/
WORKDIR /var/www/
ENTRYPOINT ["docker-php-entrypoint"]
EXPOSE 80
CMD ["apache2-foreground"]