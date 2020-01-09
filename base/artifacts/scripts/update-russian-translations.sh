#!/bin/bash
APP_PATH=/var/www/html
TEMP_PATH=/tmp/itop-rus
if [[ -d ${APP_PATH}/datamodels && -d ${APP_PATH}/dictionaries ]]; then
    rm -rf ${TEMP_PATH}
    git clone https://github.com/vbkunin/itop-rus.git ${TEMP_PATH}
    cp -r ${TEMP_PATH}/datamodels/* ${APP_PATH}/datamodels
    cp -r ${TEMP_PATH}/dictionaries/* ${APP_PATH}/dictionaries
    EXTENSIONS=${APP_PATH}/extensions/*
    for DST in ${EXTENSIONS}
    do
        SRC=${TEMP_PATH}/extensions/${DST##*/}
    if [[ -d ${SRC} ]]; then
            cp -rf ${SRC}/* ${DST}
    fi
    done
    /make-itop-config-writable.sh
    rm -rf ${TEMP_PATH}
else
    echo "Directories $APP_PATH/datamodels and $APP_PATH/dictionaries not found"
fi