#!/bin/bash
set -e  # Exit immediately if a command fails

# Update and upgrade system packages
sudo apt update
sudo apt upgrade -y

# Install Git
sudo apt install -y git

# Install Snapd
sudo apt install -y snapd
sudo systemctl enable --now snapd

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled

# Install Podman and Podman Compose
sudo apt install -y podman podman-compose

PUB_KEYS=(
"SHA256:KFjZao0NTyJokBztXwL6COA0FBlwxssZDgFBKhR4Vmw howard@pi"
)

mkdir -p ~/.ssh
chmod 700 ~/.ssh

for key in "${PUB_KEYS[@]}"; do
    grep -qxF "$key" ~/.ssh/authorized_keys || echo "$key" >> ~/.ssh/authorized_keys
done

chmod 600 ~/.ssh/authorized_keys
