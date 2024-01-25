#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

libobjc2()
{
  cd ${SRC}/libobjc2 && cd Build && \
    ninja clean
}

gnustep()
{
  # tools-make does not need cleaning so we skip and do others
}

libobjc2
gnustep