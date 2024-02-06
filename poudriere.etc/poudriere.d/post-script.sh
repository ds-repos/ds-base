#!/bin/sh

cp /etc/resolv.conf ${WORLDDIR}/etc/resolv.conf

chroot ${WORLDDIR} /bin/sh <<EOF

# Add user for live environment
mkdir -p /Users/hexley/Desktop
mkdir -p /Users/hexley/Documents
mkdir -p /Users/hexley/Downloads
pw useradd hexley -u 1000 \
  -c "Hexley" -d "/Users/hexley" \
  -g wheel -m -s /usr/local/bin/zsh -k /usr/share/skel -w none
chown -R hexley /Users/hexley

# Fetch the bsdstep zip from GitHub
fetch https://codeload.github.com/pkgdemon/bsdstep/zip/refs/heads/main -o bsdstep.zip

# Unzip the archive
unzip bsdstep.zip

# Change directory to the specified target directory
cd bsdstep-main

# Run the make install command (replace with your actual command)
make install

# Clean up the GNUstep sources after install
cd /
rm -rf /bsdstep-main
rm /bsdstep.zip

# Exit the chroot environment
exit

EOF

rm ${WORLDDIR}/etc/resolv.conf