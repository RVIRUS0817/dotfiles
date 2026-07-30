# adachin's dotfiles

## Setup

```bash
./setup.sh
```

### 1. Symlink Configuration Files

The following files will be symlinked to your home directory:

- `.gitconfig` - Git configuration
- `.commit_template` - Git commit template
- `.tmux.conf` - tmux configuration
- `.vimrc` - Vim configuration
- `.zshrc` - Zsh configuration
- `.config/nvim` - Neovim (LazyVim) configuration
- `.config/herdr/config.toml` - herdr configuration
- `.claude/settings.json` - Claude Code configuration

#### copy file

The following directories will be copied to `~/.config/`:

- `.config/ghostty` - Ghostty terminal configuration
- `.config/powerline` - Powerline configuration

### 2. Install Homebrew Packages

Automatically installs packages listed in `Brewfile`:

- Homebrew formulae (CLI tools)
- Homebrew casks (GUI applications)

## About Brewfile

Homebrew packages are managed in the `Brewfile`.  
To add or remove packages, edit the `Brewfile`.

```bash
# Update package list
brew bundle --file=Brewfile
```

## About Neovim (LazyVim)

Neovim configuration is managed in `.config/nvim/` and uses
[LazyVim](https://www.lazyvim.org/) as the base distribution.

## About Existing Files

If configuration files already exist, they will be removed and replaced with
symlinks to this repository.

## Other Manual

- aws config
- .ssh
- .terraformrc
- Raycast
