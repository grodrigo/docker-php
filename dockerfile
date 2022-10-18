FROM php:7.4-apache

RUN apt-get clean && apt-get -y update && apt-get install -y locales locales-all


# 2. Lenguaje 
#enable localisation and generates localisation files
RUN sed -i -e 's/# es_AR/es_AR/' /etc/locale.gen && \
    locale-gen
ENV LC_ALL es_AR
ENV LANG es_AR
ENV LANGUAGE es_AR


# 1. development packages
RUN apt-get install -y \
    git \
    zip \
    curl \
    sudo \
    unzip \
    libonig-dev \
    libzip-dev \
    libicu-dev \
    libbz2-dev \
    libpng-dev \
    libjpeg-dev \
    libmcrypt-dev \
    libreadline-dev \
    libfreetype6-dev \
    g++ libxml2-dev 


# 3. apache configs + document root
ENV APACHE_DOCUMENT_ROOT=/var/www/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# 4. mod_rewrite for URL rewrite and mod_headers for .htaccess extra headers like Access-Control-Allow-Origin-
RUN a2enmod rewrite headers

# 5. start with base php config, then add extensions
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# 6. Crear un alias para php artisan
RUN alias pa="/var/www/php artisan"

# 7. Instalar NPM
RUN curl -fsSL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

#8. Configurar memory limit de PHP
# RUN cd /usr/local/etc/php/conf.d/ &&  echo 'memory_limit = -1' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini
RUN cd /usr/local/etc/php/conf.d/ && \
  echo 'memory_limit = 2048M' >> /usr/local/etc/php/conf.d/docker-php-memlimit.ini  && \
  echo 'max_execution_time = 3600' >> /usr/local/etc/php/conf.d/docker-php-maxexectime.ini;

#9. Intalar extenciones PHP
RUN docker-php-ext-install \
    bz2 \
    intl \
    iconv \
    bcmath \
    opcache \
    calendar \
    mbstring \
    pdo_mysql \
    zip \
    gd soap

#10. Composer
RUN curl -sS https://getcomposer.org/installer -o composer-setup.php && php composer-setup.php --version=2.0.0 --install-dir=/usr/local/bin --filename=composer

#11. Workdir.
WORKDIR /var/www
