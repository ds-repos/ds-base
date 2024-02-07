#!/bin/sh

cp /etc/resolv.conf ${WORLDDIR}/etc/resolv.conf

chroot ${WORLDDIR} /bin/sh <<EOF

# Add user for live environment
pw useradd -n hexley -c "Hexley" -m -w none

# Fetch the bsdstep zip from GitHub
fetch https://codeload.github.com/pkgdemon/bsdstep/zip/refs/heads/main -o bsdstep.zip

# Unzip the archive
unzip bsdstep.zip

# Change directory to the specified target directory and build
cd bsdstep-main && make install

# Cleanup after build
/bsdstep-main
/bsdstep.zip
/etc/resolv.conf
/gnustep-src

# Exit the chroot environment
exit

EOF