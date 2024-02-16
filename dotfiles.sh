#!/bin/bash

# Define the dotfiles directory (replace with your actual dotfiles directory)
dotfiles_dir="$HOME/dotfiles"

# An associative array mapping files in your dotfiles directory to their desired locations
declare -A symlink_targets=(
    ["caps2esc.yaml"]="/etc/caps2esc.yaml"
    ["caps2esc.service"]="/etc/systemd/system/caps2esc.service"
    ["zshrc"]="$HOME/.zshrc"
    ["os.zsh"]="$HOME/.os.zsh"
    ["p10k.zsh"]="$HOME/.p10k.zsh"
    ["wezterm"]="$HOME/.wezterm"
    ["nvim.linux"]="$HOME/.config/nvim"
    ["file3"]="/etc/file3" # Example for a file to be linked in /etc
)

# Loop through the associative array
for file in "${!symlink_targets[@]}"; do
    src="$dotfiles_dir/$file"
    dst="${symlink_targets[$file]}"

    # Check if the source file exists
    if [ -f "$src" ]; then
        # Create a backup of the destination file if it already exists
        if [ -f "$dst" ]; then
            echo "Backing up $dst to ${dst}.bak"
            mv "$dst" "${dst}.bak"
        fi

        # Create the symlink
        ln -s "$src" "$dst"
        echo "Created symlink for $file"
    else
        echo "Source file $src not found. Skipping."
    fi
done

echo "Symlinking complete."


