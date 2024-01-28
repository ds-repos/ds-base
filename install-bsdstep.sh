#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
  echo "Switching to root user..."
  exec su -
fi

# Now the script is running as root

# Fetch the zip archive
fetch https://codeload.github.com/pkgdemon/bsdstep/zip/refs/heads/main -o bsdstep.zip

# Extract the archive
unzip bsdstep.zip

# Navigate to the project directory
cd bsdstep

# Build and install the project
make install