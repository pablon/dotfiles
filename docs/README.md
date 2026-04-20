# Dotfiles Documentation

Personal configuration files for **macOS** and **Linux**.

## Quick Start

**Prerequisites**: `git`, `sudo`

```bash
git clone https://github.com/pablon/dotfiles.git ~/dotfiles && cd ~/dotfiles/
./setup.sh          # full install (default)
./setup.sh --help   # show all options
```

Post-setup: open a new terminal session, then verify with
`git --version && zsh --version && nvim --version`.

## Setup

### Supported Platforms

- **macOS** (Intel and Apple Silicon)
- **Linux** (Debian, Ubuntu, Arch, Manjaro, Fedora, Rocky Linux, AlmaLinux)

### How It Works

Bootstrapping is **idempotent**, **robust**, and **cross-platform**. Uses GNU Stow for symlink
management — conflicts are backed up to `*.YYYYMMDD-HHMMSS` before re-linking.
Runs in Strict Mode (`set -euo pipefail`), auto-detects OS (Homebrew/APT/Pacman/DNF),
and executes numbered scripts sequentially.

`setup.sh` supports two modes:

| Command                                  | Purpose                                               |
| ---------------------------------------- | ----------------------------------------------------- |
| `./setup.sh` or `./setup.sh install`     | Full setup for a new machine                          |
| `./setup.sh update`                      | Pull latest changes, re-link dotfiles, update plugins |
| `./setup.sh --dry-run [install\|update]` | Preview without modifying anything                    |

### Setup Scripts

| Script              | Purpose                                            |
| ------------------- | -------------------------------------------------- |
| `0_sudo.sh`         | Configures passwordless sudo                       |
| `1_packages.sh`     | Installs OS packages, dev tools, Docker, ASDF      |
| `2_fonts.sh`        | Installs Nerd Fonts                                |
| `3_vim.sh`          | Configures Vim with plugins                        |
| `4_neovim.sh`       | Configures Neovim with plugins                     |
| `5_zsh.sh`          | Sets up Zsh as default shell with plugins          |
| `6_kubie.sh`        | Configures Kubie for Kubernetes context management |
| `7_ssh_config.sh`   | Sets up SSH configuration                          |
| `8_os_hardening.sh` | Applies basic OS security hardening                |

### What Gets Installed

- **Shell**: Zsh + zsh-autocomplete (real-time completions), zsh-syntax-highlighting, atuin history
- **Editors**: Vim and Neovim
- **Version Manager**: ASDF (Python, Node.js, Go, Rust)
- **Containers**: Docker with Compose and Buildx
- **Cloud CLIs**: AWS CLI, kubectl, helm, kubie
- **Git**: Conventional commits, lazygit, GPG signing
- **Terminal**: Starship prompt, Atuin history, Yazi file manager
- **macOS extras**: Rosetta 2 (Apple Silicon), Homebrew, iTerm2 integration

### Post-Setup Configuration

```bash
# Git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global user.signingkey ~/.ssh/id_ed25519.pub

# Kubernetes contexts
mkdir -p ~/.kube/configs  # place cluster configs here

# More languages via ASDF
asdf plugin add nodejs && asdf install nodejs latest && asdf global nodejs latest
```

Optional shell config files (auto-sourced if present):

| File              | Purpose                                    |
| ----------------- | ------------------------------------------ |
| `~/.aliases_work` | Work-specific aliases                      |
| `~/.completions/` | Custom completion scripts (added to FPATH) |
| `~/.exports`      | Additional environment variables           |
| `~/.secrets`      | Secrets and API keys                       |

### Maintenance

```bash
./setup.sh update                        # pull + re-link + update plugins
./setup.sh --dry-run update              # preview update without changes
stow -v .                                # re-link only (manual)
( cd ~/dotfiles && stow -vD . )          # unlink all
rm -rf ~/dotfiles                        # full removal
```

## Repository Structure

```text
~/dotfiles/
├── .aliases / .functions / .gitconfig / .tmux.conf / .vimrc
├── .zshrc          # plugin loader & orchestrator
├── .zshrc_base     # all zsh config: PATH, FPATH, fzf, completions
├── .config/
│   ├── atuin/  gh-dash/  lazygit/  nvim/  starship/  yazi/
│   └── bat/    gh/       ghostty/  k9s/
├── bin/
│   ├── commit        # interactive conventional commit helper
│   ├── git-clone     # clone to ~/projects/<host>/<user>/<repo>/
│   ├── install_kubie # kubie installer
│   ├── obsidian-sync # sync Obsidian vault
│   └── vpn-fix       # fix VPN DNS + routes
├── setup/            # 0_*.sh – 8_*.sh + .functions + pkglist.*
└── docs/
```

### Key Configs

- **Neovim** (`nvim/`): [LazyVim](https://www.lazyvim.org) base; Obsidian vault integration; Snacks image rendering; multi-language LSP
- **Git** (`.gitconfig`): GPG signing, `bin/commit` helper, custom aliases
- **Lazygit**: Delta diffs, Nerd Fonts v3, branch divergence indicators, auto-commit-prefix (Jira/Azure DevOps)
- **Kubernetes**: kubie context/namespace switching, kubecolor, helm docs generation

## Aliases & Tools

```bash
# Navigation
..  ...  cd              # zoxide-powered frecency cd

# Dev
gt  nvc  dots           # lazygit, edit nvim config, edit dotfiles

# Docker
d  db  dc  de  dps  ds  # docker, buildx build, compose, exec, watch ps, stop+rm

# Kubernetes
k   kc   kn                           # kubectl, kubie ctx, kubie ns
kge kgn  kgns  kgp  kgpw  kgs        # get events/nodes/ns/pods/pods-watch/services

# Git
ga  gd  gs  gll  gls   # add, diff, status, pretty log, log navigator

# Custom tools
bin/commit              # interactive conventional commit
bin/git-clone URL       # clone → ~/projects/<host>/<user>/<repo>/
sudo bin/vpn-fix        # fix VPN DNS + routes
bin/obsidian-sync       # sync Obsidian vault
```

Branch prefix → commit type: `feat/` → `feat:` · `fix/` → `fix:` · `docs/` → `docs:`

## Troubleshooting

| Issue                         | Fix                                                         |
| ----------------------------- | ----------------------------------------------------------- |
| Missing core dependency       | Install `git` / `curl` via system package manager           |
| GNU Stow not installed        | `brew install stow` / `apt install stow` / `pacman -S stow` |
| Permission denied             | Run as non-root user with sudo access                       |
| OS not supported              | Check supported distros above                               |
| Stow conflicts                | Run `./setup.sh --dry-run install` to preview, then re-run  |
| Zsh keybindings stop working  | Known async bug — fixed in current config. Open a new terminal session. |

```bash
pre-commit install && pre-commit run -a   # run all quality hooks
stow -nv .                                # dry-run stow
bash -n script.sh                         # syntax-check a script
```

**Pre-commit hooks**: shellcheck · yamllint · markdown-link-check · markdownlint-cli2 · detect-private-key · check-added-large-files · check-executables-have-shebangs · check-merge-conflict · check-symlinks

## Contributing

[Contributing Guide](CONTRIBUTING.md) • [Code of Conduct](CODE_OF_CONDUCT.md)

## License

[GPL v3.0](../LICENSE.md) — use, modify, and share freely.
