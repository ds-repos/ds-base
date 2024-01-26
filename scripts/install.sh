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

apps()
{
  . /usr/local/share/GNUstep/Makefiles/GNUstep.sh
  cd ${SRC}/apps-gworkspace && gmake install
  cd ${SRC}/apps-systempreferences && gmake install
  cd ${SRC}/gap/system-apps/Terminal && gmake install
  cd ${SRC}/gs-textedit && gmake install
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

settings()
{
  cp -R ../overlay/ /
  # Iterate over all users with UID between 1000 and 2000
  getent passwd | while IFS=: read -r username _ uid _; do
      if [ "$uid" -ge 1000 ] && [ "$uid" -le 2000 ]; then
          # Install xinitrc for the user
          install -o jmaloney -m 644 /usr/share/skel/dot.xinitrc /home/"$username"/.xinitrc
          # Install GNUstep defaults for the user
          su - ${username} -c defaults write NSGlobalDomain NSMenuInterfaceStyle NSMacintoshInterfaceStyle
          su - ${username} -c defaults write NSGlobalDomain GSBackHandlesWindowDecoration YES
          su - ${username} -c defaults write NSGlobalDomain GSFileBrowserHideDotFiles YES
          su - ${username} -c defaults write GWorkspace applications '{ 1 = TextEdit; 2 = Terminal; }'
      fi
  done 
}

apps
services
sysctl
sudoers
groups
settings