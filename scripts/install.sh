#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

# This variable allows getting back to this repo
CWD="$(pwd)"

gnustep_make() {
  # Check if GNUstep.sh exists
  if [ -f "/Developer/Makefiles/GNUstep.sh" ]; then
    echo "tools-make already exists. Skipping installation."
    . /Developer/Makefiles/GNUstep.sh
  else
    cd "${SRC}/tools-make" && ./configure \
      --with-thread-lib=-pthread \
      --with-layout=dubstep \
      --with-config-file=/Library/Preferences/GNUstep.conf \
      --enable-objc-nonfragile-abi \
      --enable-native-objc-exceptions \
      --with-library-combo=ng-gnu-gnu \
       && gmake && gmake install
    . /Developer/Makefiles/GNUstep.sh
  fi
}

libobjc2() {
  local repo_dir="${SRC}/libobjc2"
  local build_dir="${repo_dir}/Build"
  export GNUSTEP_INSTALLATION_DOMAIN=SYSTEM

  # Check if Build directory exists
  if [ ! -d "$build_dir" ]; then
    mkdir "$build_dir"
  fi

  # Change to Build directory and configure/build the project
  if [ -f "/System/Include/Block.h" ] ; then
    echo "libobjc already exists. Skipping installation."
  else
    (cd "$build_dir" && cmake .. -G Ninja -DCMAKE_BUILD_TYPE=Debug -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++)
    (cd "$build_dir" && ninja install)
  fi
}

gnustep() {
  local LOCALBASE="/usr/local"
  export GNUSTEP_INSTALLATION_DOMAIN=SYSTEM
  if [ -d "/System/Libraries/gnustep-base/" ] ; then
    echo "gnustep-base already exists. Skipping installation."
  else
    cd "${SRC}/libs-base" && ./configure \
      --disable-procfs \
      --with-installation-domain=SYSTEM \
      --with-zeroconf-api=mdns \
      && gmake && gmake install
  fi
  if [ -d "/System/Libraries/gnustep-gui" ] ; then
    echo "libs-gui already exists.  Skipping installation."
  else
    cd "${SRC}/libs-gui" && ./configure \
      --with-tiff-library=${LOCALBASE}/lib \
      --with-tiff-include=${LOCALBASE}/include \
      --with-jpeg-library=${LOCALBASE}/lib \
      --with-jpeg-include=${LOCALBASE}/include \
      --with-x \
      --with-x-include=${LOCALBASE}/include \
      --with-x-include=${LOCALBASE}/lib \
      && gmake && gmake install
  fi
  if [ -d "/System/Bundles/libgnustep-back-030.bundle" ] ; then
    echo "libs-back already exists. Skipping installation."
  else
    cd "${SRC}/libs-back" && ./configure \
      --with-tiff-library=${LOCALBASE}/lib \
      --with-tiff-include=${LOCALBASE}/include \
      --with-jpeg-library=${LOCALBASE}/lib \
      --with-jpeg-include=${LOCALBASE}/include \
      --with-gif-library=${LOCALBASE}/lib \
      --with-gif-include=${LOCALBASE}/include \
      --enable-graphics=cairo \
      --with-name=wayland \
      --disable-glitz \
      && gmake && gmake install
  fi
  if [ -d "/System/Applications/GWorkspace.app" ] ; then
    echo "Gworkspace already exists.  Skipping installation."
  else
    cd "${SRC}/apps-gworkspace" && ./configure && gmake && gmake install
  fi
  if [ -d "/System/Applications/SystemPreferences.app" ] ; then
    echo "SystemPreferences already exists.  Skipping installation."
  else
    cd ${SRC}/apps-systempreferences && gmake && gmake install
  fi
}

developer()
{
  export GNUSTEP_INSTALLATION_DOMAIN=NETWORK
  if [ -d "/Developer/Applications/Gorm.app" ] ; then
    echo "Gorm already exists.  Skipping installation."
  else
    cd "${SRC}/apps-gorm" && gmake && gmake install
  fi
    if [ -d "/Developer/Applications/ProjectCenter.app" ] ; then
    echo "ProjectCenter already exists.  Skipping installation."
  else
    cd "${SRC}/apps-projectcenter" && gmake && gmake install
  fi
    if [ -d "/Developer/Applications/WrapperFactory.app" ] ; then
    echo "WrapperFactory already exists.  Skipping installation."
  else
    cd "${SRC}/gs-desktop/Applications/WrapperFactory" && gmake && gmake install
  fi
}

apps()
{
  unset GNUSTEP_INSTALLATION_DOMAIN
  cd ${SRC}/gap/system-apps/Terminal && gmake && gmake install
  cd ${SRC}/gs-textedit && gmake && gmake install
  cp -R ${SRC}/gs-desktop/extra-apps/Firefox.app /Applications/
}

overlay()
{
  if [ "$(uname)" = "FreeBSD" ]; then
    cd ${CWD} && cp -R ../overlay/ /
  elif [ "$(uname)" = "Linux" ]; then
    cd ${CWD} && cp -R ../overlay-debian/* /
    cd ${CWD} && cd ../overlay/ && cp -r opt /
    cd ${CWD} && cd ../overlay/ && cp -r System /

  else
    echo "Unsupported operating system"
  fi
}

sysctl()
{
  cat ../conf/sysctl.conf | xargs dsbwrtsysctl
  service sysctl restart
}

modules()
{
  # Path to modules.conf file
  MODULES_CONF="../conf/modules.conf"

  # Read each line in modules.conf and add to kld_list in /etc/rc.conf
  while IFS= read -r module; do
  # Trim leading and trailing whitespaces
  module=$(echo "$module" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

  # Check if the module is not empty
  if [ -n "$module" ]; then
    # Use sysrc to add the module to kld_list in /etc/rc.conf
    sysrc -f /etc/rc.conf kld_list+="$module"
    echo "Added module: $module"
  fi
  done < "$MODULES_CONF"
  service kld restart
}

bonjour() {
  NSSWITCH_CONF="/etc/nsswitch.conf"

  # Check if mdns is already present before dns in the hosts line
  if ! grep -q '^hosts:[[:space:]]*files[[:space:]]\+mdns[[:space:]]\+dns' "$NSSWITCH_CONF"; then
    # Add mdns before dns in the hosts line
    awk '/^hosts:/ {gsub(/dns/, "mdns dns"); print; next} 1' "$NSSWITCH_CONF" > "$NSSWITCH_CONF.tmp" && \
    mv "$NSSWITCH_CONF.tmp" "$NSSWITCH_CONF"
    
    echo "mdns added before dns in the hosts line."
  else
    echo "mdns is already present before dns in the hosts line."
  fi
}

services() {
  # Directory path
  RC_CONF_D="/etc/rc.conf.d/"

  # Full path to the service command
  SERVICE_PATH=$(which service)

  # Iterate over files in /etc/rc.conf.d/
  for file in "$RC_CONF_D"/*; do
    # Extract the service name from the file
    service=$(basename "$file")

    # Check if the file is a regular file (not a directory)
    if [ -f "$file" ]; then
      echo "Running service $service start"
      # Run service $service start using the full path
      "$SERVICE_PATH" "$service" start
    else
      echo "File $file is not a regular file. Skipping."
    fi
  done
}

sudoers()
{
  cd ${CWD} && install -m 0440 ../sudoers.d/wheel /usr/local/etc/sudoers.d/wheel
}

fonts()
{
  sysfont=San-Francisco-Pro-Fonts 
  termfont=JetBrainsMono
  fonts_dir=/usr/share/skel/dot.local/share/fonts/

  if [ ! -d "${fonts_dir}" ] ; then
    mkdir -p $fonts_dir
  fi

  # SF Pro
  cp -R ${SRC}/$sysfont/*.otf $fonts_dir

  # JetBrains NerdFont
  mkdir ${SRC}/$termfont && cd ${SRC}/$termfont
  fetch https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/JetBrainsMono.zip
  unzip JetBrainsMono.zip
  mv ./*.ttf $fonts_dir
  cd ${SRC} && rm -rf ${SRC}/$termfont
}

themes()
{
  default_theme=dubstep-dark-theme
  cd ${SRC}/$default_theme
  gmake
  gmake install GNUSTEP_INSTALLATION_DOMAIN=SYSTEM 
}

gnustep_make
libobjc2
gnustep
developer
apps
overlay
#sysctl
#modules
#bonjour
#services
sudoers
fonts
themes
