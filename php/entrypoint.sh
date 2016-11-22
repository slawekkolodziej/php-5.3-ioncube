#!/bin/bash
PHP_INI_PATH="/etc/php/php-fpm.conf"

# Replace path to cache with provided env variable
sed -i "s|PLACEHOLDER_CACHE_HOST|${CACHE_HOST}|g" "${PHP_INI_PATH}"

exec "$@"
