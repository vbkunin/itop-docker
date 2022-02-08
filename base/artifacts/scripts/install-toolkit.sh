#!/bin/bash
APP_PATH=/var/www/html
TOOLKIT_URL=https://www.combodo.com/documentation/iTopDataModelToolkit-3.0.0.zip
TOOLKIT_FOLDER=$APP_PATH/toolkit

if [[ -d $APP_PATH ]]; then
    rm -rf $TOOLKIT_FOLDER
    curl -SL -o /tmp/toolkit.zip $TOOLKIT_URL
    unzip /tmp/toolkit.zip -d /tmp/
    mv /tmp/itop-toolkit-community $TOOLKIT_FOLDER
    echo "Go to http://localhost/toolkit to continue installation."
else
    echo "Directory $APP_PATH not found."
fi
