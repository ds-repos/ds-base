#!/bin/sh

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Source build.conf
. ../conf/build.conf

checkout()
{
  if [ ! -d "${SRC}" ]; then
    mkdir "${SRC}"
  fi

  # Read repository URLs from repos.conf and clone or pull into $SRC
  while IFS= read -r repo_var; do
    # Extract the URL from the variable definition
    repo_url=$(echo "$repo_var" | awk -F'=' '{print $2}' | tr -d '"')

    repo_name=$(basename "$repo_url" .git)
    repo_dir="${SRC}/${repo_name}"

    if [ -d "$repo_dir" ]; then
      # Directory exists, perform git pull
      cd "$repo_dir" && git pull
      cd -
    else
      # Directory doesn't exist, clone the repository
      git clone "$repo_url" "$repo_dir"
    fi
  done < ../conf/repos.conf
}

checkout