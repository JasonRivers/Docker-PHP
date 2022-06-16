FROM php:8-apache

RUN	apt-get update					&&	\
	apt-get --assume-yes install				\
		patch						\
		libfreetype6-dev				\
		libjpeg62-turbo-dev				\
		libldap2-dev	\
		libpng-dev					\
		libzip-dev					&&	\
	apt-get clean					&&	\
	rm -Rf /var/lib/apt/lists/*

RUN	docker-php-ext-configure gd --with-freetype --with-jpeg	&&	\
	docker-php-ext-install -j$(nproc) iconv gd mysqli pdo pdo_mysql sockets						&&	\
	docker-php-ext-install ldap zip

ADD apache2.proxylog.patch / 
ADD 000-default.conf /etc/apache2/sites-available/


RUN patch /etc/apache2/apache.conf /apache2.proxylog.patch && rm /apache2.proxylog.patch && \
	a2enmod rewrite				&& \
    a2enmod headers

VOLUME "/var/www"

EXPOSE 80

