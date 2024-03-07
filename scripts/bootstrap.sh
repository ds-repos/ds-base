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
  if [ "$(uname)" == "FreeBSD" ]; then
    cat ../conf/ports.conf | xargs pkg install -y
  elif [ "$(uname)" == "Linux" ]; then
    cat ../conf/dpkg.conf | xargs apt install -fy
  else
    echo "Unsupported operating system"
  fi
}

packages