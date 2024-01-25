#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

# Check if $SRC is defined
if [ -z "$SRC" ]; then
    echo "Error: \$SRC variable is not defined. Please set it in build.conf."
    exit 1
fi

# Check if the directory specified by $SRC exists
if [ ! -d "${SRC}" ]; then
    echo "Error: Directory specified by \$SRC ('$SRC') does not exist."
    exit 0
fi

libobjc2()
{
  # Check if the directory exists before running ninja clean
  if [ -d "${SRC}/libobjc2/Build" ]; then
    cd ${SRC}/libobjc2 && cd Build && ninja clean
  fi
}

gnustep()
{
  # tools-make does not need cleaning so we skip and do others
  # We must reinstall tools-make to be able to clean items from here

  # Check if the directory exists before running configure and make
  if [ -d "${SRC}/tools-make" ]; then
    cd ${SRC}/tools-make && ./configure && gmake && gmake install
  fi

  # Check if GNUstep.sh exists before sourcing it
  if [ -f "/usr/local/share/GNUstep/Makefiles/GNUstep.sh" ]; then
    . /usr/local/share/GNUstep/Makefiles/GNUstep.sh
  else
    exit 0
  fi

  # Check if the directory exists before running gmake clean
  if [ -d "${SRC}/libs-base" ]; then
    cd ${SRC}/libs-base && gmake clean
  fi

  # Check if the directory exists before running gmake clean
  if [ -d "${SRC}/libs-gui" ]; then
    cd ${SRC}/libs-gui && gmake clean
  fi

  # Check if the directory exists before running gmake clean
  if [ -d "${SRC}/libs-back" ]; then
    cd ${SRC}/libs-back && gmake clean
  fi
}

libobjc2
gnustep