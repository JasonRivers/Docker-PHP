FROM php:7-apache

RUN	apt-get update					&&	\
	apt-get --assume-yes install				\
		patch						\
		libfreetype6-dev				\
		libjpeg62-turbo-dev				\
		libmcrypt-dev					\
		libpng12-dev				&&	\
	apt-get clean					&&	\
	rm -Rf /var/lib/apt/lists/*

RUN	docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include/	&&	\
	docker-php-ext-install -j$(nproc) iconv mcrypt gd mysqli pdo pdo_mysql sockets
ADD apache2.proxylog.patch /

RUN patch /etc/apache2/apache.conf /apache2.proxylog.patch && rm /apache2.proxylog.patch

VOLUME "/var/www/html"

EXPOSE 80

