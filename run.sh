#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ "$no_database" != false ]]; then
    echo "=> Using external MySQL server"
    apachectl -DFOREGROUND || sleep infinity
else
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
fi
