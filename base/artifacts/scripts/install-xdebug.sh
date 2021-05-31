#!/bin/bash

if [[ -z $(getent hosts host.docker.internal | awk '{ print $1}') ]]; then
  REMOTE_HOST=172.17.0.1
else
  REMOTE_HOST=host.docker.internal
fi

apt-get update && apt-get install php7.3-xdebug

XDEBUG_CONF=$(php -i | grep xdebug.ini | cut -d ',' -f1)
echo zend_extension=xdebug.so > ${XDEBUG_CONF}
echo xdebug.client_port=${1:-9003} >> ${XDEBUG_CONF}
echo xdebug.client_host=${REMOTE_HOST} >> ${XDEBUG_CONF}
echo xdebug.idekey=${2:-PHPSTORM} >> ${XDEBUG_CONF}
echo xdebug.mode=debug >> ${XDEBUG_CONF}

apache2ctl -k restart

echo ""
echo "You'll probably have to change 'xdebug.client_host' if you are running on macOS or Windows. Don't forget to restart apache2 in case of any changes: apache2ctl -k restart."
echo "Your xdebug config ($XDEBUG_CONF):"
echo ""
cat ${XDEBUG_CONF}
echo ""