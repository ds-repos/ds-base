#!/bin/sh

cp /etc/resolv.conf ${WORLDDIR}/etc/resolv.conf

chroot ${WORLDDIR} /bin/sh <<EOF

# Add user for live environment
mkdir -p /Users/hexley/Apps
mkdir -p /Users/hexley/Desktop
mkdir -p /Users/hexley/Documents
mkdir -p /Users/hexley/Downloads
pw useradd hexley -c "Hexley"
chown -R hexley:staff /Users/

exit 0

# Fetch the bsdstep zip from GitHub
fetch https://codeload.github.com/pkgdemon/bsdstep/zip/refs/heads/main -o bsdstep.zip

# Unzip the archive
unzip bsdstep.zip

# Change directory to the specified target directory and build
cd bsdstep-main && make install

# Exit the chroot environment
exit

EOF