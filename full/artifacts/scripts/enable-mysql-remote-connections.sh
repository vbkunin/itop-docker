#!/usr/bin/env bash

CONF=/etc/mysql/mariadb.conf.d/90-bind-address.cnf

echo "[mysqld]" > ${CONF}
echo "bind-address=0.0.0.0" >> ${CONF}

echo "Config added (${CONF}):"
cat ${CONF}

sv restart mysql