#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

checkout()
{
  cut -d '"' -f2 ../conf/repos.conf | xargs cd /${ZPOOL}/${SRC} && git clone --depth=1
}

checkout