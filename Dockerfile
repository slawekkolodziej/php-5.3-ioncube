FROM eugeneware/php-5.3:master

# Install tools
RUN apt-get update && apt-get install -y \
	vim

# Enable mod_rewrite
RUN a2enmod rewrite

# Install Ioncube
RUN wget http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz
RUN tar xvfz ioncube_loaders_lin_x86-64.tar.gz

RUN PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;") && \
	PHP_EXT_DIR=$(php-config --extension-dir) && \
	mkdir -p $PHP_EXT_DIR && \
    cp "ioncube/ioncube_loader_lin_${PHP_VERSION}.so" $PHP_EXT_DIR && \
    cp "ioncube/ioncube_loader_lin_${PHP_VERSION}_ts.so" $PHP_EXT_DIR

RUN rm -rf ioncube ioncube_loaders_lin_x86-64.tar.gz

# Create directory for extensions config files
RUN mkdir -p /usr/local/etc/php/conf.d

# Install extensions
RUN docker-php-ext-install curl mbstring gd

# Copy php.ini
COPY php.ini /usr/local/lib