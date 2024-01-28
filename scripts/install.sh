#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

# This variable allows getting back to this repo
CWD="$(realpath)"

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
  cd ${SRC}/apps-gworkspace && ./configure && gmake && gmake install
  cd ${SRC}/apps-systempreferences && gmake && gmake install
  cd ${SRC}/gap/system-apps/Terminal && gmake && gmake install
  cd ${SRC}/gs-textedit && gmake && gmake install
}

services()
{
  cd ${CWD} && cat ../conf/rc.conf | xargs sysrc
}

sysctl()
{
  cd ${CWD} &&  cat ../conf/sysctl.conf | xargs dsbwrtsysctl
}

sudoers()
{
  cd ${CWD} && install -m 0440 ../sudoers.d/wheel /usr/local/etc/sudoers.d/wheel
}

groups()
{
  # Iterate over all users with UID between 1000 and 2000
  getent passwd | while IFS=: read -r username _ uid _; do
      if [ "$uid" -ge 1000 ] && [ "$uid" -le 2000 ]; then
          # Add the user to the specified groups
          pw groupmod video -m "$username"
          pw groupmod webcamd -m "$username"
          echo "User $username added to groups: video, webcamd"
      fi
  done
}

overlay()
{
  cp -R ../overlay/ /
}

profile()
{
  # Iterate over all users with UID between 1000 and 2000
  getent passwd | while IFS=: read -r username _ uid _; do
      if [ "$uid" -ge 1000 ] && [ "$uid" -le 2000 ]; then
          # Install xinitrc for the user
          install -o jmaloney -m 644 /usr/share/skel/dot.xinitrc /home/"$username"/.xinitrc
          # Change users shell to zsh
          chsh -s /usr/local/bin/zsh "$username"
      fi
  done 
}

defaults() {
  cp -R ../overlay/ /

  # Specify the path to the defaults.conf file
  DEFAULTS_CONF="../conf/defaults.conf"

  # Read the defaults.conf file line by line
  while IFS= read -r line; do
    # Ignore comments and empty lines
    case "$line" in
      ''|\#*) continue ;;
    esac

    # Execute the command using su for each user with UID between 1000 and 2000
    getent passwd | while IFS=: read -r username _ uid _; do
      # Skip system accounts, accounts with empty usernames, and users outside the specified UID range
      case "$username" in
        root|nologin|false|'') continue ;;
      esac

      if [ "$uid" -ge 1000 ] && [ "$uid" -le 2000 ]; then
        # Execute the command using su
        su "$username" -c "$line"
      fi
    done

  done < "$DEFAULTS_CONF"
}

libobjc2
gnustep
apps
services
sysctl
sudoers
groups
overlay
profile
defaults