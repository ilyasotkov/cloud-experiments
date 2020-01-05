#!/usr/bin/env sh

set -eux

export WEBHCAT_LOG_DIR=/opt/apache-hive-3.1.2-bin/log/

ln -sf /dev/stdout ${WEBHCAT_LOG_DIR}/webcat.log

/opt/apache-hive-3.1.2-bin/hcatalog/sbin/webhcat_server.sh foreground
