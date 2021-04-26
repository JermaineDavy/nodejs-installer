#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "This script requires sudo permissions to remove nodejs";
    exit;
fi

function remove_script {
    SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

    rm -rf $SCRIPTPATH
}

echo "Removing symlinks"

rm /usr/bin/node

if [ -f "/usr/bin/npm" ]; then
    rm /usr/bin/npm
fi

if [ -f "/usr/bin/npx" ]; then
    rm /usr/bin/npx
fi

echo "Removed all symlinks"

echo "Removing NodeJS installation"

rm -rf /usr/lib/nodejs

echo "Removed NodeJS installation"

echo "Delete temporary files (y/n)?"

read TEMP_DELETE

if [ "$TEMP_DELETE" == "yes"] || [ "$TEMP_DELETE" == "y" ]; then
    remove_script
fi