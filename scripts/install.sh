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
    ninja install
}

gnustep()
{
  cd ${SRC}/tools-make && gmake install
}

services()
{
  cat ../conf/rc.conf | xargs sysrc
}

sysctl()
{
  cat ../conf/sysctl.conf | xargs dsbwrtsysctl
}

sudoers()
{
  install -m 0440 ../sudoers.d/wheel /usr/local/etc/sudoers.d/wheel
}

libobjc2
gnustep
#services
#sysctl
#sudoers