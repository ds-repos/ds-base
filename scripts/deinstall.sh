#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

remove_local()
{
  rm -rf /Local
}

remove_system()
{
  rm -rf /System
}

remove_local
remove_system