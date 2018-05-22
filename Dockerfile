FROM php:5-apache

RUN apt-get update && \
  apt-get install -y ssmtp && \
  apt-get clean && \
  echo "FromLineOverride=YES" >> /etc/ssmtp/ssmtp.conf && \
  echo 'sendmail_path = "/usr/sbin/ssmtp -t"' > /usr/local/etc/php/conf.d/mail.ini

RUN echo postfix postfix/main_mailer_type string "'Internet Site'" | debconf-set-selections  && \
	echo postfix postfix/mynetworks string "127.0.0.0/8" | debconf-set-selections            && \
	echo postfix postfix/mailname string mailer.example.com | debconf-set-selections             && \
	apt-get update					&&	\
	apt-get --assume-yes install		\
		ssmtp						\
		patch							\
		libfreetype6-dev				\
		libjpeg62-turbo-dev				\
		libmcrypt-dev					\
		libpng12-dev				&&	\
	apt-get clean					&&	\
	rm -Rf /var/lib/apt/lists/*


RUN	docker-php-ext-configure gd --with-freetype-dir=/usr/include --with-jpeg-dir=/usr/include/	&&	\
	docker-php-ext-install -j$(nproc) iconv mcrypt gd mysql mysqli pdo pdo_mysql sockets
ADD apache2.proxylog.patch /
ADD default.conf /etc/apache2/sites-available/000-default.conf

RUN patch /etc/apache2/apache2.conf /apache2.proxylog.patch && rm /apache2.proxylog.patch

RUN a2enmod dbd rewrite authn_dbd authz_dbd

VOLUME "/var/www/html"
ADD start.sh /

EXPOSE 80
