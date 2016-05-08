#!/bin/bash
set -e

. /entrypoint/exim-entrypoint.sh

exec "$@"
