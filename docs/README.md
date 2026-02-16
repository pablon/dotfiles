# Dotfiles Documentation

Personal configuration files optimized for a seamless development experience on
**macOS** and **Linux**.

## Table of Contents

- [Quick Start](#quick-start)
- [Setup Guide](#setup-guide)
- [Configuration Overview](#configuration-overview)
- [Command Line Tools](#command-line-tools)
- [Customization](#customization)
- [Troubleshooting](#troubleshooting)
- [Contributing](#contributing)

## Quick Start

**Prerequisites**: `bc`, `git`, `curl`, `sudo`, `jq`

```bash
git clone https://github.com/pablon/dotfiles.git ~/dotfiles && cd ~/dotfiles/
./setup.sh
```

**Post-setup**: Logout and login again, then verify with
`git --version && zsh --version && nvim --version`.

## Setup Guide

### Cross-Platform Support

- **macOS** (Intel and Apple Silicon)
- **Linux** (Debian, Ubuntu, Arch, Manjaro, Fedora, Rocky Linux, AlmaLinux)

### Overview

The bootstrapping process is **idempotent**, **robust**, and **cross-platform**.
Uses GNU Stow for symlink management with automatic conflict resolution and backup.

### How It Works

1. **Environment Safety**: Runs in "Strict Mode" (`set -euo pipefail`)
2. **OS Detection**: Automatically detects your OS and uses appropriate package
   managers (Homebrew, APT, Pacman, DNF)
3. **Modular Setup**: Executes numbered scripts sequentially (0-8) for different
   phases
4. **Smart Linking**: GNU Stow symlinks dotfiles with conflict backup to
   `*.backup-<timestamp>`
5. **History Import**: Imports existing bash/zsh history into Atuin

### Setup Scripts

| Script              | Purpose                                            |
| ------------------- | -------------------------------------------------- |
| `0_sudo.sh`         | Configures passwordless sudo                       |
| `1_packages.sh`     | Installs OS packages, dev tools, Docker, ASDF      |
| `2_fonts.sh`        | Installs development fonts (Nerd Fonts)            |
| `3_vim.sh`          | Configures Vim with plugins                        |
| `4_neovim.sh`       | Configures Neovim with plugins                     |
| `5_zsh.sh`          | Sets up Zsh as default shell with plugins          |
| `6_kubie_config.sh` | Configures Kubie for Kubernetes context management |
| `7_ssh_config.sh`   | Sets up SSH configuration                          |
| `8_os_hardening.sh` | Applies basic OS security hardening                |

### What Gets Installed

#### Core Development Environment

- **Shell**: Zsh with oh-my-zsh plugins (completions, autosuggestions, syntax highlighting)
- **Editors**: Vim and Neovim with configurations
- **Version Manager**: ASDF for languages (Python, Node.js, Go, Rust)
- **Container Tools**: Docker with Compose and Buildx
- **Cloud CLIs**: AWS CLI, kubectl, helm, kubie
- **Git Workflow**: Conventional commits, lazygit, GPG signing
- **Terminal**: Starship prompt, Atuin history, Yazi file manager

#### macOS Specific

- Rosetta 2 (Apple Silicon), Homebrew packages/casks, iTerm2 integration

#### Linux Specific

- Distribution-appropriate package managers and tools

### Post-Setup Configuration

#### 1. Git Setup

```bash
# Copy .gitconfig to your $HOME
install -Cvm 600 ~/dotfiles/.gitconfig ${HOME}
# Customize .gitconfig (never symlinked by stow)
nvim ~/.gitconfig

# Or set your details at once
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global user.signingkey ~/.ssh/id_ed25519.pub
```

#### 2. Shell Customization

Edit `~/.zshrc_custom` for personal settings:

```bash
export EDITOR=nvim
export VISUAL=nvim
export OBSIDIAN_VAULT_DIR="${HOME}/Documents/obsidian"
export GIT_WORKDIR="${HOME}/code"
```

#### 3. Kubernetes Operations

```bash
mkdir -p ~/.kube/configs
# Copy your cluster configs here
kubie ctx production  # Switch contexts
```

#### 4. Additional Tools

```bash
# Install more languages via ASDF
asdf_install  # Interactive installer

# Or specific tools
asdf plugin add nodejs
asdf install nodejs latest
asdf global nodejs latest
```

### Updating & Maintenance

```bash
cd ~/dotfiles

# Update repository
git pull --stat --rebase

# Re-run setup (safe to repeat)
./setup.sh

# Or just re-link files
stow -v .
```

### Selective Re-installation

```bash
cd ~/dotfiles/setup

# Re-install specific components
bash 1_packages.sh   # Packages
bash 3_vim.sh        # Vim
bash 4_neovim.sh     # Neovim
bash 5_zsh.sh        # Zsh
```

### Uninstalling

```bash
# Unlink dotfiles (keeps repository)
( cd ~/dotfiles && stow -vD . )

# Complete removal
rm -rf ~/dotfiles
```

## Configuration Overview

### Repository Structure

```text
~/dotfiles/
├── .aliases            # Shell aliases
├── .functions          # Shell functions and utilities
├── .gitconfig          # Git configuration template
├── .tmux.conf          # tmux configuration
├── .vimrc              # Vim configuration
├── .zshrc              # Zsh main config
├── .zshrc_custom       # Custom Zsh settings
├── .config/            # Application configs
│   ├── atuin/          # Command history
│   ├── bat/            # Syntax highlighting
│   ├── gh/             # GitHub CLI
│   ├── ghostty/        # Terminal emulator
│   ├── glab-cli/       # GitLab CLI
│   ├── lazygit/        # Git TUI
│   ├── nvim/           # Neovim config
│   ├── starship/       # Shell prompt
│   └── yazi/           # File manager
├── bin/                # Custom utilities
│   ├── commit          # Interactive git commit
│   ├── vpn-fix         # VPN route fixer
│   ├── git-clone       # Smart repo cloning
│   └── install_kubie   # Kubie installer
├── setup/              # Setup scripts
│   ├── .functions      # Shared utilities
│   ├── 0_*.sh - 8_*.sh # Numbered setup phases
│   └── pkglist.*       # Package lists per OS
└── docs/               # Documentation
```

### Key Configuration Files

#### Neovim (.config/nvim/)

- [LazyVim](https://www.lazyvim.org) based setup
- Enhanced with Snacks, Obsidian, and other plugins
- LSP support for multiple languages
- Custom keymaps and options

#### Git (.gitconfig)

- Conventional commit setup with `bin/commit`
- GPG signing enabled
- Custom aliases and workflows
- Branch-specific configurations

#### Kubernetes

- Kubie for context/namespace management
- kubectl with kubecolor
- Helm with documentation generation
- Custom scripts for cluster operations

## Command Line Tools

### Custom Utilities (bin/)

#### `commit`

Interactive conventional commit helper that auto-detects commit type from branch
prefix.

```bash
bin/commit  # Interactive commit creation
```

#### `vpn-fix`

Fixes DNS resolvers and routes after VPN connection. Automatically detects
Kubernetes API servers and adds routes.

```bash
sudo bin/vpn-fix  # Run after VPN connection
```

#### `git-clone`

Smart repository cloning that organizes repos in structured directories.

```bash
bin/git-clone https://github.com/user/repo.git
# Clones to ~/projects/github.com/user/repo/
```

#### `install_kubie`

Installs kubie for Kubernetes context switching.

```bash
bin/install_kubie
```

### Key Aliases and Functions

#### Navigation

```bash
..     # cd ..
...    # cd ../..
cd     # zoxide-powered cd with frecency
```

#### Development Tools

```bash
gt     # lazygit or gitui
nvc    # Edit Neovim config
dots   # Edit dotfiles
```

#### Docker

```bash
d      # docker
db     # docker buildx build --no-cache
dc     # docker compose
de     # docker exec -ti
dps    # watch docker ps
ds     # docker stop+removal
```

#### Kubernetes

```bash
k      # kubectl (with kubecolor)
kc     # kubie ctx (context selector)
kn     # kubie ns (namespace selector)

kge    # kubectl get events
kgn    # kubectl get nodes
kgns   # kubectl get namespaces
kgp    # kubectl get pods
kgpw   # kubectl get pods --watch
kgs    # kubectl get services
```

#### Git Operations

```bash
ga     # git add
gd     # git diff
gs     # git status
gll    # pretty git log
gls    # pretty git log navigator
```

#### VPN and Networking

```bash
vpn-fix # Run VPN route fixer
```

## Customization

### Shell Customization

**Zsh Setup**: Default shell with oh-my-zsh plugins (zsh-autocomplete,
zsh-autosuggestions, zsh-syntax-highlighting)

**Key Features**:

- **History**: Atuin for unified command history
- **Prompt**: Starship for beautiful, informative prompts
- **Completion**: Enhanced tab completion
- **Syntax Highlighting**: Real-time syntax highlighting

**Personalization**: Edit `~/.zshrc_custom` for your own settings.

### Git Configuration

**Conventional Commits**: Use `bin/commit` for interactive commits:

| Branch Prefix | Commit Type |
| ------------- | ----------- |
| `feat/`       | `feat:`     |
| `fix/`        | `fix:`      |
| `docs/`       | `docs:`     |

**Advanced Features**: GPG signing, lazygit TUI, branch divergence indicators,
custom aliases.

### Kubernetes Tools

**Core Tools**: kubectl (with kubecolor), helm, kubie, stern

**Key Features**: Context/namespace switching, log filtering, pod operations,
VPN integration

## Troubleshooting

### Common Issues

#### "Missing core dependency"

Install `git` or `curl` manually via your system's package manager.

#### "GNU Stow is not installed"

```bash
# macOS
brew install stow

# Ubuntu/Debian
sudo apt install stow

# Arch
sudo pacman -S stow
```

#### "Permission denied"

Run setup as non-root user with sudo access.

#### "OS not supported"

Check that your Linux distribution is supported (Debian, Ubuntu, Arch, Fedora, etc.).

#### Stow Conflicts

Check backup files in your home directory (`*.backup-*`) before re-running.

### Pre-commit Hooks

Quality assurance hooks:

```bash
# Install and run hooks
pre-commit install
pre-commit run -a

# Run specific hooks
pre-commit run shellcheck -a
pre-commit run yamllint -a
```

**Configured hooks**:

- **shellcheck**: Shell script linting (severity=error)
- **yamllint**: YAML validation (relaxed, max 500 chars)
- **markdown-link-check**: Verify documentation links
- **detect-private-key**: Block credential commits
- **check-added-large-files**: Prevent large file commits

### Testing Setup Scripts

```bash
# Test individual scripts
cd setup && bash 1_packages.sh

# Dry-run stow operations
stow -nv .

# Syntax check scripts
bash -n script.sh
```

## Contributing

### Code Style Guidelines

#### Shell Script Standards

- **Strict Mode**: Always use `set -euo pipefail`
- **Error Handling**: Use `_error()`, `_warning()`, `_success()` functions
- **Quoting**: Always quote variables: `"${VAR}"`
- **Functions**: Use lowercase with underscores: `my_function()`
- **Constants**: Use `readonly UPPERCASE`

#### Example Script Template

```bash
#!/usr/bin/env bash
##########################################################
# Description: Brief description
# Author: https://github.com/pablon
# Compatibility: Linux & macOS (Bash 3.2+)
##########################################################
set -euo pipefail
source "$(dirname "${0}")/.functions"

main() {
    # Implementation
}
main "$@"
```

#### Naming Conventions

| Type            | Convention              | Example                  |
| --------------- | ----------------------- | ------------------------ |
| Exported/Global | `UPPERCASE_UNDERSCORES` | `export OS="darwin"`     |
| Local variables | `lowercase_underscores` | `local_var="value"`      |
| Functions       | `lowercase_underscores` | `detect_os()`            |
| Constants       | `readonly UPPER`        | `readonly VERSION="1.0"` |

### Security Considerations

- **Never commit secrets**, API keys, or credentials
- Use environment variables for sensitive config
- Pre-commit hooks detect private keys and large files
- Script permissions: `chmod 0755`

### Git Workflow

- Use conventional commits with `bin/commit` helper
- Branch prefixes determine commit types automatically
- GPG signing enabled for all commits

### Quality Assurance

- Pre-commit hooks ensure code quality
- Manual testing of setup scripts
- Cross-platform compatibility testing

This is a personal dotfiles repository, but feel free to use it as inspiration
for your own setup.

## License

[GPL v3.0](../LICENSE.md) - feel free to use, modify, and share.
