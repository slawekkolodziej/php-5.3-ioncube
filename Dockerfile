FROM eugeneware/php-5.3:master

# Install tools
RUN apt-get update \
 && apt-get install -y \
	vim \
	exim4-daemon-light \
	supervisor \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
 && find /var/log -type f | while read f; do echo -ne '' > $f; done;

# Enable mod_rewrite
RUN a2enmod rewrite
RUN a2enmod headers

# Install Ioncube
RUN wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz \
 && tar xvfz ioncube_loaders_lin_x86-64.tar.gz \
 && PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;") \
 && PHP_EXT_DIR=$(php-config --extension-dir) \
 && mkdir -p $PHP_EXT_DIR \
 && cp "ioncube/ioncube_loader_lin_${PHP_VERSION}.so" $PHP_EXT_DIR \
 && cp "ioncube/ioncube_loader_lin_${PHP_VERSION}_ts.so" $PHP_EXT_DIR \
 && rm -rf ioncube ioncube_loaders_lin_x86-64.tar.gz

# Install PHP-Redis
RUN wget https://github.com/phpredis/phpredis/archive/2.2.7.tar.gz \
 && tar xvfz 2.2.7.tar.gz \
 && cd phpredis-2.2.7 \
 && phpize \
 && ./configure \
 && make \
 && make install \
 && cd .. \
 && rm -rf phpredis-2.2.7 2.2.7.tar.gz


# Create directory for extensions config files
RUN mkdir -p /usr/local/etc/php/conf.d

# Install extensions
RUN docker-php-ext-install curl mbstring gd soap

# Configure PHP
COPY php/php.ini /usr/local/lib
RUN mkdir -p /usr/local/etc/php/conf.d

# Configure exim
COPY exim/set-exim4-update-conf /bin/
RUN chmod a+x /bin/set-exim4-update-conf

# Configure supervisor
COPY supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY supervisor/supervisord-*.conf /etc/supervisor/conf.d/
RUN mkdir -p \
	/var/lock/apache2 \
	/var/run/apache2 \
	/var/log/supervisor

# Configure entrypoints
RUN mkdir -p /entrypoint

COPY entrypoint.sh /entrypoint/entrypoint.sh
COPY exim/entrypoint.sh /entrypoint/exim-entrypoint.sh
COPY php/entrypoint.sh /entrypoint/php-entrypoint.sh

RUN chmod a+x /entrypoint/*.sh

ENTRYPOINT ["/entrypoint/entrypoint.sh"]

EXPOSE 80
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord-web.conf"]