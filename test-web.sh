#!/bin/sh
 docker run -it --rm -p 80:80 -v $(pwd):/var/www/html grodrigo/php:5.6-apache
