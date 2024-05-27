FROM ubuntu:14.04

# RUN sed -i -- 's/archive/old-releases/g' /etc/apt/sources.list && \
#   sed -i -- 's/# archive/old-releases/g' /etc/apt/sources.list

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

### Uncomment to build with custom configs
#COPY php5 /usr/local/etc/php
#COPY apache2/apache2.conf /etc/apache2/apache2.conf

## Entrypoint and apache foreground
# COPY docker-php-ext-* docker-php-entrypoint /usr/local/bin/
# RUN rm -f /etc/apt/apt.conf.d/20proxy
RUN a2enmod rewrite
# COPY apache2-foreground /usr/local/bin/
WORKDIR /var/www/

# ENTRYPOINT ["docker-php-entrypoint"]
EXPOSE 80

CMD apachectl -D FOREGROUND
