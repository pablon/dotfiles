# Setup Guide

## Overview

The bootstrapping process for this dotfiles repository is designed to be
**idempotent**, **robust**, and **cross-platform**. It supports both
**Linux** (Debian, Ubuntu, Arch, Manjaro, Fedora, Rocky Linux, AlmaLinux)
and **macOS**.

The entry point is the `setup.sh` script in the root directory, which
orchestrates a multi-phase setup process.

## Prerequisites

The script automatically checks for core dependencies, but you should
ideally have:

- **Bash 3.2+** (Standard on macOS and Linux)
- **Git** (To clone the repo)
- **Curl** (For downloading external resources)
- **Sudo** (For system package installations)

## How It Works

### 1. Environment Safety

The script runs in "Strict Mode" (`set -euo pipefail`) to ensure that any
error, unset variable, or failed pipe causes an immediate exit. This
prevents partial installs or corrupted states.

### 2. Path Detection

Regardless of where you clone the repository, the script dynamically
locates itself. You do not need to clone it specifically to `~/dotfiles`.

### 3. OS Detection & Compatibility

The setup automatically detects your operating system and uses
appropriate package managers:

- **macOS**: Homebrew (brew)
- **Debian/Ubuntu**: APT (apt)
- **Arch/Manjaro**: Pacman (pacman)
- **Fedora/Rocky/AlmaLinux**: DNF (dnf)

### 4. Modular Setup Scripts

The script executes numbered setup scripts from the `setup/` directory
in sequential order:

| Script              | Description                                              |
| ------------------- | -------------------------------------------------------- |
| `0_sudo.sh`         | Configures passwordless sudo for the current user        |
| `1_packages.sh`     | Installs OS packages, dev tools, Docker, ASDF, languages |
| `2_fonts.sh`        | Installs development fonts (Nerd Fonts)                  |
| `3_vim.sh`          | Configures Vim with plugins                              |
| `4_neovim.sh`       | Configures Neovim with plugins                           |
| `5_zsh.sh`          | Sets up Zsh as default shell with plugins                |
| `6_kubie_config.sh` | Configures Kubie for Kubernetes context management       |
| `7_ssh_config.sh`   | Sets up SSH configuration                                |
| `8_os_hardening.sh` | Applies basic OS security hardening                      |

Each script runs in an isolated subshell to prevent environment pollution.

### 5. Smart Linking (GNU Stow)

The script uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink
dotfiles from the repo to your `$HOME` directory.

**Conflict Resolution Strategy:**
Instead of overwriting existing files blindly, the script:

1. Performs a `stow` dry-run (`-n`).
2. Parses the output to detect conflicts (files that already exist in
   `$HOME`).
3. Backs up conflicting files to `~/<filename>.backup-<timestamp>`.
4. Applies the symlinks safely.

_Note: This logic is compatible with both Linux and macOS versions of
Stow, avoiding non-portable flags like `sort -V`._

### 6. Shell History Import

After successful setup, the script imports existing shell history
(bash/zsh) into Atuin for unified command history across sessions.

## Usage

```bash
# 1. Clone the repository
git clone https://github.com/pnazar/dotfiles.git
cd dotfiles

# 2. Run the setup
./setup.sh
```

## What Gets Installed

### Core Tools

- **Package Managers**: Homebrew, APT, Pacman, DNF (OS-specific)
- **Version Managers**: ASDF for language runtimes
- **Shell**: Zsh with plugins (completions, autosuggestions, syntax
  highlighting)
- **Editors**: Vim and Neovim with configurations
- **Containerization**: Docker with Compose and Buildx
- **Cloud Tools**: AWS CLI, kubectl, helm, kubie

### Development Tools

- **Languages**: Python, Node.js, Go, Rust (via ASDF)
- **Utilities**: curl, wget, jq, yq, git, tmux, lazygit
- **Terminal**: Starship prompt, Atuin history, Yazi file manager
- **Security**: Ansible with SOPS, OpenSSL tools

### macOS Specific

- Rosetta 2 (for Apple Silicon)
- Homebrew packages and casks
- iTerm2 shell integration (if detected)

## Troubleshooting

- **"Missing core dependency"**: Install `git` or `curl` via your system's
  package manager manually.
- **"GNU Stow is not installed"**: The `setup/1_packages.sh` script
  installs Stow. If it fails, install Stow manually (`brew install stow`
  or `apt install stow`) and re-run.
- **"Permission denied"**: Run the script as a non-root user with sudo
  access.
- **"OS not supported"**: Check that your Linux distribution is in the
  supported list.
- **Stow conflicts**: Check backup files in your home directory
  (`*.backup-*`) before re-running.

## Post-Setup Actions

After successful completion:

- **Reload your shell**: `source ~/.zshrc` or logout/login
- **Test installations**: Run `kubectl version`, `docker --version`,
  `asdf --version`
- **Configure Kubernetes**: Place kubeconfig files in `~/.kube/configs/`
  and use `kubie ctx` to switch contexts
