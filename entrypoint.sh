#!/bin/bash
set -e

env > /etc/environment

. /entrypoint/exim-entrypoint.sh
. /entrypoint/php-entrypoint.sh

exec "$@"
