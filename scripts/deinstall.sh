#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

remove_local()
{
  if [ -d "/Local/" ] ; then
    rm -rf /Local
  fi  
}

remove_opt()
{
  if [ -d "/opt" ] ; then
    rm -rf /opt
  fi
}

remove_system()
{
  if [ -d "/System "] ; then
    rm -rf /System
  fi
}

remove_local
remove_opt
remove_system