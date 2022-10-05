#!/bin/bash

chown -R www-data:www-data /var/www/html/conf
chown -R www-data:www-data /var/www/html/data

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mysql_install_db > /dev/null 2>&1
    echo "=> Done!"
    /create-mysql-admin-user.sh
else
    echo "=> Using an existing volume of MySQL"
fi

exec /sbin/my_init
