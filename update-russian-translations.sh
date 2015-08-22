#!/bin/bash
APP_PATH=/app
TEMP_PATH=/tmp/itop-rus
if [[ -d $APP_PATH/datamodels && -d $APP_PATH/dictionaries ]]; then
    rm -rf $TEMP_PATH
    git clone https://github.com/vbkunin/itop-rus.git $TEMP_PATH
    cp -r $TEMP_PATH/datamodels/* $APP_PATH/datamodels
    cp -r $TEMP_PATH/dictionaries/* $APP_PATH/dictionaries
    /make-itop-config-writable.sh
else
    echo "Directories $APP_PATH/datamodels and $APP_PATH/dictionaries not found"
fi