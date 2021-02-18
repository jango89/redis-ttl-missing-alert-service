#!/bin/sh

. /tmp/env/env_global.sh

for SCRIPT_PATH in /tmp/services/*; do
  . "$SCRIPT_PATH"
  bash /tmp/alert_redis_non_expiring_elements.sh
done
