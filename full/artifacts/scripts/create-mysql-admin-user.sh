#!/usr/bin/env bash

mariadbd-safe > /dev/null 2>&1 &

RET=1
while [[ RET -ne 0 ]]; do
    echo "=> Waiting for confirmation of MySQL service startup"
    sleep 5
    mariadb -uroot -e "status" > /dev/null 2>&1
    RET=$?
done

PASS=${MYSQL_PASS:-$(pwgen -s 12 1)}
_word=$( [ "${MYSQL_PASS}" ] && echo "preset" || echo "random" )
echo "=> Creating MySQL admin user with ${_word} password"

mariadb -uroot -e "CREATE USER 'admin'@'%' IDENTIFIED BY '$PASS'"
mariadb -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%' WITH GRANT OPTION"
# remove_anonymous_users (from mysql_secure_installation script)
mariadb -uroot -e "DELETE FROM mysql.global_priv WHERE User='';"

echo "=> Done!"

echo "========================================================================"
echo "Your MySQL user 'admin' has password: $PASS"
echo "You can now connect to this MySQL Server using:"
echo ""
echo "    mysql -uadmin -p$PASS -h<host> -P<port>"
echo ""
echo "Please remember to change the above password as soon as possible!"
echo "MySQL user 'root' has no password but only allows local connections"
echo "========================================================================"

mariadb-admin -uroot shutdown