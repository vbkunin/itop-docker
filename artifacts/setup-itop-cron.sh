#!/bin/bash
USER=$1
PWD=$2
LOG_DIR=$3
LOG_FILE=$4

if [[ -z $USER ]] || [[ -z $PWD ]]; then
	echo "Specify username and password of iTop cron profile as the first and the second argument."
	echo "Usage: /setup-itop-cron.sh username password [log_folder [log_file]]"
	exit 1
fi

if [[ -z $LOG_DIR ]]; then
	LOG_DIR=/dev/null
	LOG_FILE=''
elif [[ ! -d $LOG_DIR ]]; then
	echo "Log folder $LOG_DIR not found."
	exit 1
elif [[ -z $LOG_FILE ]]; then
	LOG_FILE=itop-cron.log
fi

echo "*/5 * * * * root /usr/bin/php /app/webservices/cron.php --auth_user=$USER --auth_pwd=$PWD >> $LOG_DIR$LOG_FILE 2>&1" > /etc/cron.d/itop
echo "Following job was added to cron:"
cat /etc/cron.d/itop

