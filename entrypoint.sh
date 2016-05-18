#!/bin/bash
set -e

. /entrypoint/exim-entrypoint.sh
. /entrypoint/php-entrypoint.sh

exec "$@"
