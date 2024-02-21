#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source config for environment variables
. ../conf/build.conf

remove_sources()
{
  if [ -d "/gnustep-src" ] ; then 
    rm -rf /gnustep-src
  fi
}

remove_sources