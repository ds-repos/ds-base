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
  cat ../conf/ports.conf | xargs pkg install -y
  # Check if the architecture is amd64
  if [ "$(uname -m)" = "amd64" ]; then
    # Install packages from the list
    cat ../conf/ports-amd64.conf | xargs pkg install -y
    echo "Packages installed successfully."
  else
    return 0
  fi
}

packages