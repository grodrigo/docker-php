#!/bin/sh
 docker run -it --rm -p 80:80 -v $(pwd):/var/www/html juanitomint/php7
