FROM php:8-apache

RUN	apt-get update					&&	\
	apt-get --assume-yes install		\
		patch							\
		libfreetype6-dev				\
		libjpeg62-turbo-dev				\
		libldap2-dev					\
		libpng-dev						\
		libzip-dev					&&	\
	apt-get clean					&&	\
	rm -Rf /var/lib/apt/lists/*

RUN	docker-php-ext-configure gd --with-freetype --with-jpeg	&&	\
	docker-php-ext-install -j$(nproc) iconv gd mysqli pdo pdo_mysql sockets						&&	\
	docker-php-ext-install ldap zip bcmath exif

ADD apache2.proxylog.patch / 
ADD 000-default.conf /etc/apache2/sites-available/


RUN patch /etc/apache2/apache.conf /apache2.proxylog.patch && rm /apache2.proxylog.patch && \
	a2enmod rewrite				&& \
    a2enmod headers

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
	php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
	php composer-setup.php && \
	php -r "unlink('composer-setup.php');" && \
	mv composer.phar /usr/local/bin/composer

VOLUME "/var/www"

EXPOSE 80

