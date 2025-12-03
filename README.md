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

#### copy file
- `.config/` - Various application configuration directory

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

## About Existing Files

If configuration files already exist, they will be automatically backed up with a `.backup` extension.

## Other Manual

- aws config
- .ssh
- .terraformrc
- Raycast
