#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

libobjc2() {
  local repo_dir="${SRC}/libobjc2"
  local build_dir="${repo_dir}/Build"

  # Check if Build directory exists
  if [ ! -d "$build_dir" ]; then
    mkdir "$build_dir"
  fi

  # Change to Build directory and configure/build the project
  (cd "$build_dir" && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++)
  (cd "$build_dir" && ninja install)
}

gnustep()
{
  cd ${SRC}/tools-make && ./configure && gmake && gmake install
  . /usr/local/share/GNUstep/Makefiles/GNUstep.sh
  cd ${SRC}/libs-base && ./configure && gmake && gmake install
  cd ${SRC}/libs-gui && ./configure && gmake && gmake install
  cd ${SRC}/libs-back && ./configure && gmake && gmake install
}

apps()
{
cd ${SRC}/apps-gworkspace && ./configure && gmake
cd ${SRC}/apps-systempreferences && gmake
cd ${SRC}/gap/system-apps/Terminal && gmake
cd ${SRC}/gs-textedit && gmake
}

libobjc2
gnustep
apps
