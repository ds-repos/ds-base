#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

packages()
{
  cat ../conf/ports.conf | xargs pkg install -fy
}

datasets()
{
  zfs list ${ZPOOL}/${SRC} >/dev/null 2>/dev/null || \
	        zfs create -o compression=lz4 ${ZPOOL}/${SRC}
}

packages
datasets