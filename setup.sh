#!/bin/bash

# dotfiles setup script
# This script creates symbolic links from the home directory to any dotfiles in this directory

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Setting up dotfiles from $DOTFILES_DIR"

# List of files/directories to symlink
dotfiles=(
    ".gitconfig"
    ".commit_template"
    ".tmux.conf"
    ".vimrc"
    ".zshrc"
)

# Create symlinks
for file in "${dotfiles[@]}"; do
    src="$DOTFILES_DIR/$file"
    dest="$HOME/$file"
    
    if [ -e "$dest" ] || [ -L "$dest" ]; then
        echo "Backing up existing $file to ${file}.backup"
        mv "$dest" "${dest}.backup"
    fi
    
    if [ -e "$src" ]; then
        echo "Creating symlink: $dest -> $src"
        ln -s "$src" "$dest"
    else
        echo "Warning: $src does not exist, skipping..."
    fi
done

# Copy specific .config items
config_items=(
    "ghostty"
    "powerline"
)

config_dest="$HOME/.config"
mkdir -p "$config_dest"

for item in "${config_items[@]}"; do
    src="$DOTFILES_DIR/.config/$item"
    dest="$config_dest/$item"
    
    if [ -e "$src" ]; then
        echo "Copying .config/$item to $dest"
        cp -r "$src" "$dest"
    else
        echo "Warning: $src does not exist, skipping..."
    fi
done

echo "Dotfiles setup complete!"

# Install Homebrew packages from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    echo ""
    echo "Installing Homebrew packages from Brewfile..."
    
    # Check if Homebrew is installed
    if ! command -v brew &> /dev/null; then
        echo "Homebrew is not installed. Please install Homebrew first:"
        echo '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
        exit 1
    fi
    
    # Run brew bundle
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    echo "Homebrew packages installation complete!"
else
    echo "Warning: Brewfile not found, skipping Homebrew package installation"
fi
