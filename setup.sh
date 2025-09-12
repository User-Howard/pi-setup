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


cd /tmp
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
tar xzf nvim-linux-arm64.tar.gz
sudo mv nvim-linux-arm64 /opt/neovim
sudo ln -sf /opt/neovim/bin/nvim /usr/local/bin/nvim

PUB_KEYS=(
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINcOewWEnZFe9iNhKoYXweSzhl+wFU2GnWLvlr34pdGI howard@pi"
"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAREs9VDpSRklrIKKuKERzuLfQCP/CiWswbni/ufZ7bm"
)

mkdir -p ~/.ssh
chmod 700 ~/.ssh

for key in "${PUB_KEYS[@]}"; do
    grep -qxF "$key" ~/.ssh/authorized_keys || echo "$key" >> ~/.ssh/authorized_keys
done

chmod 600 ~/.ssh/authorized_keys


# Fix Ghostty Terminal Error
echo 'export TERM=xterm-256color' >> ~/.bashrc
