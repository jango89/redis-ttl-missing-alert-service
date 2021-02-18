#!/bin/sh

. env/env_global.sh

for SCRIPT_PATH in services/*; do
  . "$SCRIPT_PATH"
  bash alert_redis_non_expiring_elements.sh
done
