#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

# Source GNUstep.sh
 . /usr/local/share/GNUstep/Makefiles/GNUstep.sh

apps()
{ 
  cd ${SRC}/gs-textedit && gmake uninstall
  cd ${SRC}/gap/system-apps/Terminal && gmake uninstall
  cd ${SRC}/apps-systempreferences && gmake uninstall
  cd ${SRC}/apps-gworkspace && gmake uninstall
}

gnustep()
{
  cd ${SRC}/libs-base && gmake uninstall
  cd ${SRC}/libs-gui && gmake uninstall
  cd ${SRC}/libs-back && gmake uninstall
  cd ${SRC}/tools-make && gmake uninstall
}

libobjc2()
{
  cd ${SRC}/libobjc2/Build && \
    ninja uninstall
}

apps
gnustep
libobjc2