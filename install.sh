#!/bin/bash

# if [ "$EUID" -ne 0 ]; then
#     echo "This script requires sudo permissions to install nodejs";
#     exit;
# fi

function remove_script {
    SCRIPTPATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"

    rm -rf $SCRIPTPATH
}

function check_for_dependencies () {
    REQUIRED_DEPENDENCY_PATH="$(which $1)"

    if [ "${#REQUIRED_DEPENDENCY_PATH}" == 0 ]; then
        echo -e "This script requires \e[1m'$1' \e[21m";
        echo -e "\nExiting script. Goodbye."

        exit
    fi
}

function download_file() {
    URL="https://nodejs.org/dist/v$1/node-v$1-$2-$3.tar.xz"
    
    STATUS_CODE=$(curl -o /dev/null --silent --head --write-out "%{http_code}\n" "$URL")

    if [ $STATUS_CODE -ne 200 ]; then
        echo "The requested version of NodeJS does not exist"
        exit
    fi

    wget $URL
}

check_for_dependencies curl
check_for_dependencies wget

MACHINE_NAME="$(uname -s)"

case "${MACHINE_NAME}" in
    Linux*)     MACHINE=linux;;
    Darwin*)    MACHINE=darwin;;
    *)          MACHINE="UNKNOWN:${MACHINE_NAME}"
esac

CPU_ARCHITECTURE="$(uname -p)"

if [ "$CPU_ARCHITECTURE" == "x86_64" ]; then
    CPU_ARCHITECTURE="x64"
fi

if [ "$MACHINE" == "linux" ] && [ "$MACHINE" == "darwin" ]; then
    echo "Unable to perform installation on this device of type '${MACHINE_NAME}'"
fi

LTS_VERSION="14.16.1"
LATEST_VERSION="16.0.0"
VERSION_PROMPT="Please select which version to install (Default 1): "
VERSION_OPTIONS=(
    "$LTS_VERSION (LTS - Recommended)"
    "$LATEST_VERSION (Latest)"
    "Other"
    "Quit"
)

PS3="$VERSION_PROMPT"
select VERSION_OPTION in "${VERSION_OPTIONS[@]}"; do
    case "$REPLY" in
        1) SELECTED_OPTION=1;;
        2) SELECTED_OPTION=2;;
        3) SELECTED_OPTION=3;;
        4) echo "Exiting script. Good Bye."; exit;;
        *) echo -e "Invalid option selected. Defaulting to \e[1mOption 1\e[21m";
            SELECTED_OPTION=0;;
    esac
    break
done

echo $SELECTED_OPTION

if [ $SELECTED_OPTION -le 1 ]; then
    VERSION=$LTS_VERSION
elif [ $SELECTED_OPTION -eq 2 ]; then
    VERSION=$LATEST_VERSION
else
    echo "Please provide the version number you would like to install (Eg. 12.0.5): "
    read SELECTED_VERSION

    VERSION=$SELECTED_VERSION
fi

download_file $VERSION $MACHINE $CPU_ARCHITECTURE

tar xf "node-v$VERSION-$MACHINE-$CPU_ARCHITECTURE.tar.xz"

mv "node-v$VERSION-$MACHINE-$CPU_ARCHITECTURE" "nodejs"

sudo mv "nodejs" "/usr/lib/"

sudo ln -s "/usr/lib/nodejs/bin/node" "/usr/bin/node"

if [ -f "/usr/lib/nodejs/bin/npm" ]; then
    sudo ln -s "/usr/lib/nodejs/bin/npm" "/usr/bin/npm"
fi

if [ -f "/usr/lib/nodejs/bin/npx" ]; then
    sudo ln -s "/usr/lib/nodejs/bin/npx" "/usr/bin/npx"
fi

echo "Delete temporary files (y/n default n)?"

read TEMP_DELETE

if [ "$TEMP_DELETE" == "yes"] || [ "$TEMP_DELETE" == "y" ]; then
    remove_script
fi