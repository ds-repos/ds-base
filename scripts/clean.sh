#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

# Check if $SRC is defined
if [ -z "$SRC" ]; then
    echo "Error: \$SRC variable is not defined. Please set it in build.conf."
    exit 1
fi

# Check if the directory specified by $SRC exists
if [ ! -d "${SRC}" ]; then
    echo "Error: Directory specified by \$SRC ('$SRC') does not exist."
    exit 0
fi

remove_source()
{
  rm -rf /gnustep-src
}

remove_source