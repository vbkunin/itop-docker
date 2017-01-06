#!/bin/bash
APP_PATH=/app
EXT_NAME=portal-announcement
EXT_FOLDER=$APP_PATH/extensions/$EXT_NAME

if [[ -d $APP_PATH/extensions ]]; then
    rm -rf $EXT_FOLDER
    git clone --depth=1 https://github.com/itop-itsm-ru/$EXT_NAME.git $EXT_FOLDER
    /make-itop-config-writable.sh
else
    echo "Directories $APP_PATH/extensions not found"
fi
