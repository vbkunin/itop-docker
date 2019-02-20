#!/bin/bash

apt-get update && apt-get install php-xdebug

XDEBUG_CONF=$(php -i | grep xdebug.ini | cut -d ',' -f1)
echo 'zend_extension=xdebug.so' > $XDEBUG_CONF
echo 'xdebug.remote_autostart=on' >> $XDEBUG_CONF
echo 'xdebug.remote_enable=on' >> $XDEBUG_CONF
echo 'xdebug.remote_port=9000' >> $XDEBUG_CONF
echo 'xdebug.remote_host=172.17.0.1 #docker.for.mac.localhost' >> $XDEBUG_CONF
echo 'xdebug.idekey="PHPSTORM"' >> $XDEBUG_CONF
apache2ctl -k restart

echo ""
echo "You'll probably have to change 'xdebug.remote_host' if you are running on macOS. Don't forget to restart apache2 in case of any changes: apache2ctl -k restart."
echo "xdebug config: $XDEBUG_CONF"
cat $XDEBUG_CONF
echo ""