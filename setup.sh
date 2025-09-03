#!/bin/bash
set -e  # Exit immediately if a command fails

# Update and upgrade system packages
sudo apt update
sudo apt upgrade -y

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled

# Install Podman and Podman Compose
sudo apt install -y podman podman-compose
