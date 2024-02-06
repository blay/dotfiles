#!/bin/bash

# Update and Upgrade
sudo apt update && sudo apt upgrade -y

# Install common utilities
sudo apt install -y git zsh ripgrep silversearcher-ag fzf curl wget tmux htop vim neovim tree ncdu

# Install ZSH

# Clone dotfiles repository
git clone https://github.com/blay/dotfiles.git ~/dotfiles

# Create symlinks for dotfiles
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/aliases ~/.aliases
mkdir -p ~/.config/
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/shell ~/.shell

# Change default shell to Zsh
chsh -s $(which zsh)

