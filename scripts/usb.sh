#!/bin/sh

# Only run as superuser
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Source config for environment variables
. ../conf/build.conf
. ../poudriere.etc/poudriere.conf

datasets()
{
  zfs list ${ZPOOL}/${PRODUCT} >/dev/null 2>/dev/null || \
	        zfs create -o compression=lz4 ${ZPOOL}/${PRODUCT}
  zfs list ${ZPOOL}/${PRODUCT}/cache >/dev/null 2>/dev/null || \
	        zfs create -o compression=lz4 ${ZPOOL}/${PRODUCT}/cache
  zfs list ${ZPOOL}/${PRODUCT}/cache/ccache >/dev/null 2>/dev/null || \
	        zfs create -o compression=lz4 ${ZPOOL}/${PRODUCT}/cache/ccache
  zfs list ${ZPOOL}/${PRODUCT}/cache/distfiles >/dev/null 2>/dev/null || \
	        zfs create -o compression=lz4 ${ZPOOL}/${PRODUCT}/cache/distfiles
  zfs list ${ZPOOL}/${PRODUCT}/cache/pkg >/dev/null 2>/dev/null || \
	        zfs create -o compression=lz4 ${ZPOOL}/${PRODUCT}/cache/pkg
}

packages()
{
  which git >/dev/null 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Installing git.."
    pkg install -y devel/git
  fi

  which ccache >/dev/null 2>/dev/null
  if [ $? -ne 0 ]; then
    echo "Installing ccache.."
    pkg install -y devel/ccache
  fi

  pkg info -q poudriere-devel >/dev/null 2>/dev/null
  if [ "$?" != "0" ]; then
    pkg install -y poudriere-devel
    if [ "$?" != "0" ]; then
      echo "Failed installing poudriere-devel!"
      exit 1
    fi
  fi
}

jail()
{
  # Check if jail exists
  poudriere -e ../poudriere.etc jail -l | grep -q ${PRODUCT}
  if [ $? -eq 1 ] ; then
    # If jail does not exist create it
    poudriere -e ../poudriere.etc jail -c -j ${PRODUCT} -v ${OSVERSION}-RELEASE -K GENERIC
  else
    # Update jail if it exists
    poudriere -e ../poudriere.etc jail -u -j ${PRODUCT}
  fi
}

image()
{
  # Build image
  poudriere -e ../poudriere.etc image \
    -t usb \
    -s 6g \
    -j ${PRODUCT} \
    -c ../overlay \
    -A ./poudriere.etc/poudriere.d/post-script.sh \
    -n bsdstep \
    -h bsdstep
}

datasets
packages
jail
image