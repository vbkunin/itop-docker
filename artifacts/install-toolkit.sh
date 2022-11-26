#!/bin/bash
APP_PATH=/var/www/html
TOOLKIT_URL=https://github.com/Combodo/itop-toolkit-community/archive/refs/tags/3.0.0.zip
TOOLKIT_FOLDER=$APP_PATH/toolkit

if [[ -d $APP_PATH ]]; then
    rm -rf $TOOLKIT_FOLDER
    wget -O /tmp/toolkit.zip $TOOLKIT_URL
    unzip /tmp/toolkit.zip -d /tmp/
    cp -r /tmp/toolkit $APP_PATH && rm -rf /tmp/toolkit*
    echo "Go to http://localhost/toolkit to continue installation."
else
    echo "Directory $APP_PATH not found."
fi
