#!/bin/bash

# Update and Upgrade
sudo apt update && sudo apt upgrade -y

# Install common utilities
sudo apt install -y git zsh ripgrep silversearcher-ag fzf curl wget tmux htop make gcc cmake tree fd-find fonts-firacode

sudo snap install nvim --classic
sudo snap install keepassxc
#sudo snap install obsidian --classic

# install Wezterm
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/JetBrains/JetBrainsMono/master/install_manual.sh)"

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt update && sudo apt install wezterm -y

# Install ZSH
git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# Clone dotfiles repository
git clone https://github.com/blay/dotfiles.git ~/dotfiles

# Create symlinks for dotfiles
ln -sf ~/dotfiles/zshrc ~/.zshrc
ln -sf ~/dotfiles/aliases ~/.aliases
mkdir -p ~/.config/
ln -sf ~/dotfiles/nvim ~/.config/nvim
ln -sf ~/dotfiles/shell ~/.shell
ln -sf ~/dotfiles/wezterm.lua ~/.wezterm.lua


# Change default shell to Zsh
chsh -s $(which zsh)

