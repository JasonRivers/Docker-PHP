FROM php:7-apache

RUN	apt-get update					&&	\
	apt-get --assume-yes install				\
		patch						\
		libfreetype6-dev				\
		libjpeg62-turbo-dev				\
		libmcrypt-dev					\
		libpng-dev					&&	\
	apt-get clean					&&	\
	rm -Rf /var/lib/apt/lists/*

RUN	pecl install mcrypt-1.0.1		&& \
	docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include/	&&	\
	docker-php-ext-install -j$(nproc) iconv gd mysqli pdo pdo_mysql sockets						&&	\
	docker-php-ext-enable mcrypt
ADD apache2.proxylog.patch /
ADD 000-default.conf /etc/apache2/sites-available/

RUN patch /etc/apache2/apache.conf /apache2.proxylog.patch && rm /apache2.proxylog.patch && \
	a2enmod rewrite				&& \
    a2enmod headers


VOLUME "/var/www/html"

EXPOSE 80

