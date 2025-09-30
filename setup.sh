#!/bin/bash
set -e  # Exit immediately if a command fails

# Update and upgrade system packages
sudo apt update
sudo apt upgrade -y

# Install Git, Tmux
sudo apt install -y git tmux

# Install Snapd
sudo apt install -y snapd
sudo systemctl enable --now snapd

# Install Tailscale
curl -fsSL https://tailscale.com/install.sh | sh
sudo systemctl enable --now tailscaled

# Install Podman and Podman Compose
sudo apt install -y podman podman-compose

# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian bookworm stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Add the repository to Apt sources:
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# install lazyvim
cd /tmp
wget https://github.com/neovim/neovim/releases/latest/download/nvim-linux-arm64.tar.gz
tar xzf nvim-linux-arm64.tar.gz
sudo mv nvim-linux-arm64 /opt/neovim
sudo ln -sf /opt/neovim/bin/nvim /usr/local/bin/nvim

git clone https://github.com/LazyVim/starter ~/.config/nvim

# install coder
curl -fsSL https://coder.com/install.sh | sh

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
