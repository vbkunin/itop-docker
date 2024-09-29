#!/bin/bash
APP_PATH=/var/www/html
TOOLKIT_URL=https://github.com/Combodo/itop-toolkit-community/archive/refs/tags/3.2.zip
TOOLKIT_FOLDER=$APP_PATH/toolkit

if [[ -d $APP_PATH ]]; then
    rm -rf $TOOLKIT_FOLDER
    curl -SL -o /tmp/toolkit.zip $TOOLKIT_URL
    unzip /tmp/toolkit.zip -d /tmp/
    mv /tmp/itop-toolkit-community-3.2 $TOOLKIT_FOLDER
    echo "Go to http://localhost/toolkit to continue installation."
else
    echo "Directory $APP_PATH not found."
fi
