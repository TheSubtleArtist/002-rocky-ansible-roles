#!/usr/bin/env bash
set -euo pipefail

PRIVATE_KEY_PATH=/vagrant/vagrant/.ssh/ansible_lab
DESTINATION_KEY_PATH=/home/vagrant/.ssh/ansible_lab

echo "Configuraing the SSH access for ansible controller"


if [ ! -f "$PRIVATE_KEY_PATH" ]; then
    echo "Private key not found at $PRIVATE_KEY_PATH"
    exit 1
fi

mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
cp "$PRIVATE_KEY_PATH" "$DESTINATION_KEY_PATH"
chmod 600 "$DESTINATION_KEY_PATH"
chown -R vagrant:vagrant /home/vagrant/.ssh