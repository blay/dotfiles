#!/bin/bash

set -e

DOTFILES_DIR="$HOME/dotfiles"
BACKUP_DIR="$HOME/.dotfiles_backup"
FORCE=false

# Parse flags
if [[ "$1" == "--force" ]]; then
    FORCE=true
    echo "⚡ Force mode enabled: existing files will be overwritten without backup."
fi

mkdir -p "$BACKUP_DIR"
mkdir -p "$HOME/.config"

# === Files to symlink into $HOME ===
FILES=(
    "zshrc:.zshrc"
    "gitconfig:.gitconfig"
    "os.zsh:.os.zsh"
    "p10k.zsh:.p10k.zsh"
    "aliases:.aliases"
    "wezterm.lua.mac:.wezterm.lua"
    "shell:.shell"
)

# === Config directories to symlink into ~/.config ===
CONFIGS=(
    "nvim.mac:nvim"
    "karabiner:karabiner"
)

echo ""
echo "=== Symlinking dotfiles into ~ ==="
for mapping in "${FILES[@]}"; do
    src_name="${mapping%%:*}"
    dest_name="${mapping##*:}"

    src="$DOTFILES_DIR/$src_name"
    dest="$HOME/$dest_name"

    if [ ! -e "$src" ]; then
        echo "⚠️ Source $src not found. Skipping."
        continue
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$FORCE" = true ]; then
            echo "Overwriting $dest"
            rm -rf "$dest"
        else
            echo "Backing up existing $dest to $BACKUP_DIR/"
            mv "$dest" "$BACKUP_DIR/"
        fi
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
done

echo ""
echo "=== Symlinking configs into ~/.config/ ==="
for mapping in "${CONFIGS[@]}"; do
    src_name="${mapping%%:*}"
    dest_name="${mapping##*:}"

    src="$DOTFILES_DIR/config/$src_name"
    dest="$HOME/.config/$dest_name"

    if [ ! -e "$src" ]; then
        echo "⚠️ Source $src not found. Skipping."
        continue
    fi

    if [ -e "$dest" ] || [ -L "$dest" ]; then
        if [ "$FORCE" = true ]; then
            echo "Overwriting $dest"
            rm -rf "$dest"
        else
            echo "Backing up existing $dest to $BACKUP_DIR/"
            mv "$dest" "$BACKUP_DIR/"
        fi
    fi

    echo "Linking $src -> $dest"
    ln -s "$src" "$dest"
done

echo ""
echo "✅ All symlinks created successfully!"

