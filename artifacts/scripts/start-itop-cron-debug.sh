#!/bin/bash

DEFAULT_SERVER_NAME=localhost
DEFAULT_AUTH_USER=admin
DEFAULT_AUTH_PWD=

PHP_IDE_CONFIG="serverName=${1:-$DEFAULT_SERVER_NAME}" php /var/www/html/webservices/cron.php --auth_user=${2:-$DEFAULT_AUTH_USER} --auth_pwd=${3:-$DEFAULT_AUTH_PWD} --verbose=1 --debug=1