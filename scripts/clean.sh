#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source config for environment variables
. ../conf/build.conf
. ../conf/poudriere.conf

remove_sources()
{
  rm -rf /gnustep-src >/dev/null 2>/dev/null || true
}

pool()
{
  zpool destroy ${PRODUCT} >/dev/null 2>/dev/null || true
}

device()
{
  if [ -b "/dev/md0" ] ; then mdconfig -d -u 0 ; fi
}

jail()
{
  if [ ! -f "/usr/local/etc/poudriere.conf" ] ; then
    return 0
  else
    # Check if jail exists
    poudriere -e ../conf jail -l | grep -q ${PRODUCT}
    if [ $? -eq 0 ] ; then
      # If jail exists remove it
      yes | poudriere -e ../conf  jail -d -j ${PRODUCT}
    fi
  fi
}

datasets()
{
  zfs destroy -r ${ZPOOL}/${PRODUCT} >/dev/null 2>/dev/null || true
}

remove_sources
pool
device
jail
datasets