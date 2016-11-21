#!/bin/bash
PHP_INI_PATH="/usr/local/etc/php-fpm.conf"

# Replace path to cache with provided env variable
sed -i "s|PLACEHOLDER_CACHE_HOST|${CACHE_HOST}|g" "${PHP_INI_PATH}"

exec "$@"
