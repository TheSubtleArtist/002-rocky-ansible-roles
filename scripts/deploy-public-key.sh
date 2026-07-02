#!/usr/bin/env bash
set -euo pipefail

PUBLIC_KEY_SOURCE="/vagrant/vagrant/.ssh/ansible_lab.pub"
AUTHORIZED_KEYS="/home/vagrant/.ssh/authorized_keys"

if [ ! -f "$PUBLIC_KEY_SOURCE" ]; then
    echo "Public key not found at $PUBLIC_KEY_SOURCE"
    exit 1
fi

mkdir -p /home/vagrant/.ssh
chmod 700 /home/vagrant/.ssh
touch "$AUTHORIZED_KEYS"

# search the contents of the authorized_keys file for the public key and add it if it doesn't exist
if ! grep -q -f "$PUBLIC_KEY_SOURCE" "$AUTHORIZED_KEYS"; then
    cat "$PUBLIC_KEY_SOURCE" >> "$AUTHORIZED_KEYS"
    echo "Public key added to authorized_keys"
else
    echo "Public key already exists in authorized_keys"
fi  

chmod 600 "$AUTHORIZED_KEYS"
chown -R vagrant:vagrant /home/vagrant/.ssh 

echo "SSH access for ansible controller configured successfully"