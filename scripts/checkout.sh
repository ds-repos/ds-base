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
    mkdir -p "${SRC}"
  fi

  # Read repository URLs from repos.conf and clone or pull into $SRC
  while IFS= read -r repo_var; do
    # Extract the key and value
    repo_key=$(echo "$repo_var" | awk -F'=' '{print $1}' | tr -d '[:space:]')
    repo_value=$(echo "$repo_var" | awk -F'=' '{print $2}' | tr -d '[:space:]')

    if [ -z "$repo_value" ]; then
      continue  # Skip lines without a valid repository URL
    fi

    repo_name=$(basename "$repo_value" .git)
    repo_dir="${SRC}/${repo_name}"

    if [ -d "$repo_dir" ]; then
      # Directory exists, perform git pull
      echo "Updating repository: $repo_name"
      cd "$repo_dir" && git pull
      if [ $? -ne 0 ]; then
        echo "Error updating repository: $repo_name"
      fi
      cd -
    else
      # Directory doesn't exist, clone the repository
      echo "Cloning repository: $repo_name"
      git clone "$repo_value" "$repo_dir"
      if [ $? -ne 0 ]; then
        echo "Error cloning repository: $repo_name"
      fi
    fi
  done < ../conf/repos.conf
}

checkout