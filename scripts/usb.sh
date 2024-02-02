#!/bin/sh

# Only run as superuser
if [ "$(id -u)" != "0" ]; then
  echo "This script must be run as root" 1>&2
  exit 1
fi

# Source config for environment variables
. ../conf/build.conf
. ../conf/poudriere.conf

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
  poudriere -e ../config jail -l | grep -q ${PRODUCT}
  if [ $? -eq 1 ] ; then
    # If jail does not exist create it
    poudriere -e ../config jail -c -j ${PRODUCT} -v ${OSVERSION}-RELEASE -K GENERIC
  else
    # Update jail if it exists
    poudriere -e ../config jail -u -j ${PRODUCT}
  fi
}

image()
{
  # Build image
  if [ -d "/mnt/var/cache/pkg" ] ; then umount /mnt/var/cache/pkg ; fi 

  zpool destroy ${PRODUCT} >/dev/null 2>/dev/null || true
  
  if [ -c "/dev/md0" ] ; then mdconfig -d -u 0 ; fi
  if [ -f "/${ZPOOL}/${PRODUCT}/${PRODUCT}.img" ] ; then rm /${ZPOOL}/${PRODUCT}/${PRODUCT}.img ; fi
  
  truncate -s 2g /${ZPOOL}/${PRODUCT}/${PRODUCT}.img
  mdconfig -f /${ZPOOL}/${PRODUCT}/${PRODUCT}.img -u 0
  
  gpart create -s gpt md0
  gpart add -t efi -s 40M md0
  gpart add -t freebsd-zfs md0
  newfs_msdos -F 32 -c 1 /dev/md0p1
  mount -t msdosfs /dev/md0p1 /mnt
  mkdir -p /mnt/EFI/BOOT
  cp /${ZPOOL}/${PRODUCT}/poudriere/jails/${PRODUCT}/boot/loader.efi /mnt/EFI/BOOT/BOOTX64.efi
  umount /mnt

  zpool create -f -o cachefile=/tmp/zpool.cache -O mountpoint=none -O atime=off -O canmount=off -O compression=zstd-9 ${PRODUCT} /dev/md0p2
  zfs create -o canmount=off ${PRODUCT}/ROOT
  zfs create -o mountpoint=legacy ${PRODUCT}/ROOT/default
  zfs send ${ZPOOL}/${PRODUCT}/poudriere/jails/${PRODUCT}@clean | zfs recv -F ${PRODUCT}/ROOT/default
  mount -t zfs ${PRODUCT}/ROOT/default /mnt
  cp /etc/resolv.conf /mnt/etc/resolv.conf
  mkdir /mnt/var/cache/pkg
  mount -t nullfs /${ZPOOL}/${PRODUCT}/cache/pkg /mnt/var/cache/pkg

  chroot /mnt mkdir -p /Users/hexley/Desktop
  chroot /mnt mkdir -p /Users/hexley/Documents
  chroot /mnt mkdir -p /Users/hexley/Downloads
  chroot /mnt pw useradd hexley -u 1000 \
  -c "Hexley" -d "/Users/hexley" \
  -g wheel -G video -G webcamd -m -s /usr/local/bin/zsh -k /usr/share/skel -w none
  chroot /mnt chown -R hexley:hexley /home/hexley

  chroot /mnt /bin/sh <<EOF

# Fetch the bsdstep zip from GitHub
fetch https://codeload.github.com/pkgdemon/bsdstep/zip/refs/heads/main -o bsdstep.zip

# Unzip the archive
unzip bsdstep.zip

# Change directory to the specified target directory
cd bsdstep-main

# Run the make install command (replace with your actual command)
make install

# Clean up the GNUstep sources after install
make clean

# Exit the chroot environment
exit

EOF
  
  umount /mnt/var/cache/pkg
  rmdir /mnt/var/cache/pkg
  rm -rf /mnt/usr/src
  rm /mnt/etc/resolv.conf
  zpool set bootfs=${PRODUCT}/ROOT/default ${PRODUCT}
  zpool export ${PRODUCT}
  mdconfig -d -u 0
}

datasets
packages
jail
image