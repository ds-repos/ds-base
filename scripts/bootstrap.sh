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
  if [ -d "/Users/hexley" ]; then
    echo "Running inside builder image. Skipping pkg bootstrap."
    return 0
  else
    cat ../conf/ports.conf | xargs pkg install -y
  fi
}

packages