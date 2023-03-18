#!/bin/bash

VOLUME_HOME="/var/lib/mysql"

if [[ ! -d $VOLUME_HOME/mysql ]]; then
    echo "=> An empty or uninitialized MySQL volume is detected in $VOLUME_HOME"
    echo "=> Installing MySQL ..."
    mariadb-install-db --user=mysql > /dev/null 2>&1
    echo "=> Done!"
    /create-mysql-admin-user.sh
else
    echo "=> Using an existing volume of MySQL"
fi
