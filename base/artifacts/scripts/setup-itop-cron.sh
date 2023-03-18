#!/bin/bash
USER=$1
PASSWORD=$2
LOG_FILE=$3

if [[ -z $USER ]] || [[ -z $PASSWORD ]]; then
	echo "Specify username and password of iTop cron profile as the first and the second argument. Default log file is /var/www/html/log/cron.log."
	echo "Usage: /setup-itop-cron.sh <username> <password> [--without-logs | <log_file>]"
	exit 1
fi

if [[ $LOG_FILE == '--without-logs' ]]; then
	LOG_FILE=/dev/null
elif [[ -z $LOG_FILE ]]; then
	LOG_FILE=/var/www/html/log/cron.log
elif [[ -z ${LOG_FILE##*/} ]]; then
	echo "It looks like a directory name: $LOG_FILE. Did you forget to specify file name itself?"
	exit 1	
elif [[ ! -d $(dirname $LOG_FILE) ]]; then
	echo "Log directory $(dirname $LOG_FILE)/ not found. Is it exists?"
	exit 1	
fi

if [[ $LOG_FILE != /dev/null ]]; then
	touch $LOG_FILE;
	chown www-data:www-data $LOG_FILE;
fi

echo "*/1 * * * * www-data /usr/bin/php /var/www/html/webservices/cron.php --auth_user=$USER --auth_pwd=$PASSWORD >> $LOG_FILE 2>&1" > /etc/cron.d/itop
echo -e "\nThe following job has been added to cron (/etc/cron.d/itop):"
cat /etc/cron.d/itop

if [[ $LOG_FILE != /dev/null ]]; then
	sed -i -e "1s:^.*\( {\):$LOG_FILE\1:" /etc/logrotate.d/itop-cron
	echo -e "\nThe logrotate config (/etc/logrotate.d/itop-cron):"
	cat /etc/logrotate.d/itop-cron
fi
echo -e "\nBye!"