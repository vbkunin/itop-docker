#!/bin/bash

chown -R www-data:www-data /var/www/html/conf

exec /sbin/my_init
