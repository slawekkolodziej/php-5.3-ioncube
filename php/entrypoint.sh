#!/bin/bash
set -e

PHP_INI_PATH="/usr/local/lib/php.ini"

# Replace path to cache with provided env variable
sed -i "s|PLACEHOLDER_CACHE_HOST|${CACHE_HOST}|g" "${PHP_INI_PATH}"

exec "$@"
