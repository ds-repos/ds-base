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
  cd ${SRC}/libobjc2/Build && \
    ninja uninstall
}

gnustep()
{
  cd ${SRC}/tools-make && gmake uninstall
  cd ${SRC}/libs-base && gmake uninstall
  cd ${SRC}/libs-gui && gmake uninstall
  cd ${SRC}/libs-back && gmake uninstall
  find /usr -name GNUstep | xargs rm -rf
}

libobjc2
gnustep