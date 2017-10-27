FROM php:7-apache
RUN apt update
RUN apt install -y git libssl-dev
RUN pecl install xdebug
RUN pecl install mongodb
RUN docker-php-ext-install bcmath 
RUN docker-php-ext-install mysqli
RUN docker-php-ext-install zip
COPY php /usr/local/etc/php
COPY apache2/apache2.conf /etc/apache2/apache2.conf

### install composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \ 
php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
php composer-setup.php \
php -r "unlink('composer-setup.php');" \
mv composer.phar /usr/local/bin/composer

RUN a2enmod rewrite 