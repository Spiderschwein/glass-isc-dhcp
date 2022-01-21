#!/bin/bash
set -e

echo "generating config"
confd -onetime -backend env -confdir /home/node/app/config -config-file config/conf.d/glass_config.toml

exec "$@"