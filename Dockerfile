FROM php:5-apache

RUN	apt-get update					&&	\
	apt-get --assume-yes install		\
		libfreetype6-dev				\
		libjpeg62-turbo-dev				\
		libmcrypt-dev					\
		libpng12-dev

RUN	docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include/	&&	\
	docker-php-ext-install -j$(nproc) iconv mcrypt gd mysql mysqli pdo pdo_mysql

VOLUME "/var/www/html"

EXPOSE 80

