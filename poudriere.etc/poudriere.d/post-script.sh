#!/bin/sh

cp /etc/resolv.conf ${WORLDDIR}/etc/resolv.conf

chroot ${WORLDDIR} /bin/sh <<EOF

# Fetch the DUBstep zip from GitHub
fetch https://codeload.github.com/ds-repos/ds-build/zip/refs/heads/main -o ds-build.zip

# Unzip the archive
unzip ds-build.zip

# Change directory to the specified target directory and build
cd ds-build-main && make install

# Cleanup after build
rm -rf /ds-build-main
rm /ds-build.zip
rm /etc/resolv.conf
rm -rf /gnustep-src

# Exit the chroot environment
exit

EOF