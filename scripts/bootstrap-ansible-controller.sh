#!/usr/bin/env bash

# -e option instructs bash to immediately exit if any command [1] has a non-zero exit status
# -u option instructs bash to treat unset variables as an error and exit immediately
# -o option returns the exit status of the last command in the pipe that failed
set -euo pipefail

# Update the system and install dependencies
sudo dnf makecache -y

# Install required packages for Ansible controller
sudo dnf install -y python3 python3-pip git openssh-clients

# Install Ansible using pip
python3 -m pip install --user ansible

echo "Ensuring user-local Python path is available"
grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || \
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"

echo "Validating Ansible installation"
"$HOME/.local/bin/ansible" --version