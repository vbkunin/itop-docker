#!/bin/bash
APP_PATH=/app
EXT_NAME=portal-announcement
EXT_FOLDER=$APP_PATH/extensions/$EXT_NAME

if [[ -d $EXT_FOLDER ]]; then
    cd $EXT_FOLDER
    git pull
    /make-itop-config-writable.sh
else
    echo "Directories $EXT_FOLDER not found"
fi
