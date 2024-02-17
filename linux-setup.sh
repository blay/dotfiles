#!/bin/bash

# Define a list of applications to install
applications="git ripgrep neovim fzf zsh curl wget tmux fd-find"

# Function to install packages for Fedora
install_fedora() {
    echo "Installing packages for Fedora..."
    sudo dnf install -y $applications
}

# Function to install packages for Ubuntu
install_ubuntu() {
    echo "Installing packages for Ubuntu..."
    sudo apt update
    sudo apt install -y $applications
}

# Function to install packages for Arch
install_arch() {
    echo "Installing packages for Arch..."
    sudo pacman -Syu --noconfirm
    sudo pacman -S --noconfirm $applications
}

echo "Select your Linux distribution:"
echo "1. Fedora"
echo "2. Ubuntu"
echo "3. Arch"
read -p "Enter your choice (1/2/3): " distro

case $distro in
    1) install_fedora ;;
    2) install_ubuntu ;;
    3) install_arch ;;
    *)
        echo "Invalid choice. Exiting."
        exit 1
        ;;
esac

# Install ZSH
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# Clone dotfiles repository
git clone https://github.com/blay/dotfiles.git ~/dotfiles

bash ~/dotfiles/dotfiles.sh

echo "Installation complete."
