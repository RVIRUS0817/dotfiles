#!/bin/bash
# dotfiles setup script This script creates symbolic links from the home directory to any dotfiles in this directory

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "Setting up dotfiles from $DOTFILES_DIR"

# List of files/directories to symlink
dotfiles=(
  ".gitconfig"
  ".commit_template"
  ".tmux.conf"
  ".vimrc"
  ".zshrc"
  ".p10k.zsh"
)

if [ -d ~/.tmux/plugins/tpm ]; then
  echo "TPM already installed, skipping..."
else
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Create symlinks
for file in "${dotfiles[@]}"; do
  src="$DOTFILES_DIR/$file"
  dest="$HOME/$file"

  if [ ! -e "$src" ]; then
    echo "Warning: $src does not exist, skipping..."
    continue
  fi

  if [ "$(readlink "$dest")" = "$src" ]; then
    echo "$file already symlinked, skipping..."
    continue
  fi

  if [ -e "$dest" ] || [ -L "$dest" ]; then
    echo "Removing existing $file"
    rm -rf "$dest"
  fi

  echo "Creating symlink: $dest -> $src"
  ln -s "$src" "$dest"
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
    sudo cp -r "$src" "$dest"
  else
    echo "Warning: $src does not exist, skipping..."
  fi
done

echo "Dotfiles setup complete!"

# Install tmux plugins via TPM
echo ""
echo "Installing tmux plugins..."
if [ -f ~/.tmux/plugins/tpm/bin/install_plugins ]; then
  ~/.tmux/plugins/tpm/bin/install_plugins
  echo "Tmux plugins installation complete!"
else
  echo "Warning: TPM not found, skipping tmux plugin installation"
fi

# Install Homebrew packages from Brewfile
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
  echo ""
  echo "Installing Homebrew packages from Brewfile..."

  # Check if Homebrew is installed
  if ! command -v brew &>/dev/null; then
    echo "Homebrew is not installed. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Add Homebrew to PATH for Apple Silicon
    if [ -f /opt/homebrew/bin/brew ]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi

  # Run brew bundle
  brew bundle --file="$DOTFILES_DIR/Brewfile"
  echo "Homebrew packages installation complete!"
else
  echo "Warning: Brewfile not found, skipping Homebrew package installation"
fi

# Setup Neovim (LazyVim) config
echo ""
echo "Setting up Neovim config..."
nvim_src="$DOTFILES_DIR/.config/nvim"
nvim_dest="$HOME/.config/nvim"

if [ "$(readlink "$nvim_dest")" = "$nvim_src" ]; then
  echo "Neovim config already symlinked, skipping..."
else
  if [ -e "$nvim_dest" ] || [ -L "$nvim_dest" ]; then
    echo "Removing existing nvim config"
    rm -rf "$nvim_dest"
  fi
  echo "Creating symlink: $nvim_dest -> $nvim_src"
  ln -s "$nvim_src" "$nvim_dest"
  echo "Neovim config setup complete!"
fi

# Setup herdr config
echo ""
echo "Setting up herdr config..."
herdr_src="$DOTFILES_DIR/.config/herdr/config.toml"
herdr_dest="$HOME/.config/herdr/config.toml"

mkdir -p "$HOME/.config/herdr"

if [ "$(readlink "$herdr_dest")" = "$herdr_src" ]; then
  echo "herdr config already symlinked, skipping..."
else
  if [ -e "$herdr_dest" ] || [ -L "$herdr_dest" ]; then
    echo "Removing existing herdr config"
    rm -f "$herdr_dest"
  fi
  echo "Creating symlink: $herdr_dest -> $herdr_src"
  ln -s "$herdr_src" "$herdr_dest"
  echo "herdr config setup complete!"
fi

# Setup Claude Code config
echo ""
echo "Setting up Claude Code config..."
claude_src="$DOTFILES_DIR/.claude/settings.json"
claude_dest="$HOME/.claude/settings.json"

mkdir -p "$HOME/.claude"

if [ "$(readlink "$claude_dest")" = "$claude_src" ]; then
  echo "Claude Code config already symlinked, skipping..."
else
  if [ -e "$claude_dest" ] || [ -L "$claude_dest" ]; then
    echo "Removing existing Claude Code config"
    rm -f "$claude_dest"
  fi
  echo "Creating symlink: $claude_dest -> $claude_src"
  ln -s "$claude_src" "$claude_dest"
  echo "Claude Code config setup complete!"
fi

# Setup Python environment with pyenv
echo ""
echo "Setting up Python environment..."
if command -v pyenv &>/dev/null; then
  pyenv install 3.12.0
  pyenv global 3.12.0
  pip install --upgrade pip
  pip install powerline-status
  echo "Python environment setup complete!"
else
  echo "Warning: pyenv is not installed. Please install pyenv first."
fi

# Setup git completion scripts
echo ""
echo "Setting up git completion scripts..."
mkdir -p ~/.zsh
curl -o ~/.zsh/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash
curl -o ~/.zsh/_git https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.zsh
echo "Git completion scripts setup complete!"
