#!/bin/bash

chown -R www-data:www-data /var/www/html/conf
chown -R www-data:www-data /var/www/html/data

exec /sbin/my_init
