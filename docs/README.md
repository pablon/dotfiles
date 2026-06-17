# Dotfiles Documentation

This repo manages my shell, editor, and terminal configs across macOS and Linux.
Run `setup.sh` on a fresh machine and it installs everything: packages, dotfiles,
Zsh plugins, Neovim, Docker, Kubernetes CLIs, and more — all in one shot.

## Scope

This page covers the repository layout, setup flow, and key configuration notes.
It does **not** duplicate every detail from each config file — check the file itself
or the [Contributing Guide](../CONTRIBUTING.md) for deeper dives.

## Audience

Anyone setting up these dotfiles, maintaining them, or contributing changes.

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

The setup is **safe to re-run** (idempotent), **cross-platform**, and **hands-off**.
It uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink config files from this
repo into your home directory — no copying, no manual moves. If a target file already exists,
Stow backs it up with a timestamp (`*.YYYYMMDD-HHMMSS`) before replacing it.
Every script runs in Strict Mode (`set -euo pipefail`), auto-detects your OS
(macOS → Homebrew, Debian → APT, Arch → Pacman, Fedora → DNF),
and runs numbered phases in order.

`setup.sh` supports two modes:

| Command                                  | Purpose                                               |
| ---------------------------------------- | ----------------------------------------------------- |
| `./setup.sh` or `./setup.sh install`     | Full setup for a new machine                          |
| `./setup.sh update`                      | Pull latest changes, re-link dotfiles, update plugins |
| `./setup.sh --dry-run [install\|update]` | Preview without modifying anything                    |

### Setup Scripts

| Script                   | Purpose                                                        |
| ------------------------ | -------------------------------------------------------------- |
| `0_sudo.sh`              | Configures passwordless sudo                                   |
| `1_packages.sh`          | Installs OS packages, dev tools, Docker, ASDF                  |
| `2_fonts.sh`             | Installs Nerd Fonts                                            |
| `3_vim.sh`               | Configures Vim with plugins                                    |
| `4_neovim.sh`            | Configures Neovim with plugins                                 |
| `5_zsh.sh`               | Sets up Zsh as default shell with plugins                      |
| `6_kubie.sh`             | Configures Kubie for Kubernetes context management             |
| `7_ssh_config.sh`        | Sets up SSH configuration                                      |
| `8_os_hardening.sh`      | Applies basic OS security hardening                            |
| `9_optimize_browsers.sh` | Hardens and optimizes Firefox, Zen, and Chrome for performance |

### What Gets Installed

| Category            | What you get                                                                                                  |
| ------------------- | ------------------------------------------------------------------------------------------------------------- |
| **Shell**           | Zsh as default shell + autocomplete (real-time completions), syntax highlighting, Atuin (history with search) |
| **Editors**         | Vim and Neovim — both pre-configured with plugins, LSP, and Obsidian integration                              |
| **Version Manager** | ASDF — manage multiple runtimes (Python, Node.js, Go, Rust) per project                                       |
| **Containers**      | Docker + Compose + Buildx — build, run, and orchestrate containers                                            |
| **Cloud CLIs**      | AWS CLI, kubectl, helm, kubie — manage cloud and Kubernetes from day one                                      |
| **Git**             | LazyGit TUI, GPG signing, conventional commits helper (`bin/commit`)                                          |
| **Terminal**        | Starship prompt, Atuin (history), Yazi (file manager) — all styled and ready                                  |
| **macOS extras**    | Rosetta 2 (Apple Silicon), Homebrew, iTerm2 integration                                                       |

### Post-Setup Configuration

```bash
# Git identity
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global user.signingkey ~/.ssh/id_ed25519.pub

# Kubernetes contexts
mkdir -p ~/.kube/configs  # place cluster configs here

# More languages via ASDF
asdf plugin add nodejs &&
  asdf install nodejs latest &&
  asdf -u nodejs latest
```

**Required** shell config files sourced automatically by `.zshrc`:

| File            | Purpose                                |
| --------------- | -------------------------------------- |
| `~/.aliases`    | Main aliases (managed by Stow)         |
| `~/.functions`  | Main shell functions (managed by Stow) |
| `~/.zshrc_base` | Extended Zsh config (managed by Stow)  |

> [!IMPORTANT]
> **NEVER EDIT THESE!** ☝️

**User-owned** shell config files sourced automatically by `.zshrc_base` if they exist (never commited):

| File                  | Purpose                                                                      |
| --------------------- | ---------------------------------------------------------------------------- |
| `~/.aliases_custom`   | Override or extend aliases without editing `.aliases`                        |
| `~/.aliases_work`     | Work-specific aliases (just to keep them separated from `~/.aliases_custom`) |
| `~/.completions/`     | Custom completion scripts directory (added to `FPATH` via `.zshrc`)          |
| `~/.exports`          | Additional environment variables                                             |
| `~/.functions_custom` | Override or extend functions without editing `.functions`                    |
| `~/.secrets`          | Secrets and API keys (chmod 0600 recommended)                                |
| `~/.zshrc_custom`     | Override or extend functions without editing `.zshrc`                        |

> [!TIP]
> **ALL your customizations go here** ☝️

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
├── setup/            # 0_*.sh – 9_*.sh + .functions + pkglist.*
├── CONTRIBUTING.md
└── docs/
    ├── CODE_OF_CONDUCT.md
    ├── README.md
    └── docker.md
```

### Key Configs

- **Neovim** (`nvim/`): [LazyVim](https://www.lazyvim.org) base; Obsidian vault integration; Snacks image rendering;
  multi-language LSP
- **Git** (`.gitconfig`): GPG signing, `bin/commit` helper, custom aliases
- **Lazygit**: Delta diffs, Nerd Fonts v3, branch divergence indicators, auto-commit-prefix (Jira/Azure DevOps)
- **Kubernetes**: kubie context/namespace switching, kubecolor, helm docs generation

## Aliases & Tools

These are the main shortcuts you get after setup. The full list lives in `.aliases`
(auto-sourced by Zsh). Type the alias directly in your terminal — no prefix needed.

```bash
# Navigation — zoxide learns your habits, so `cd` gets smarter over time
..  ...  cd              # go up 1/2 dirs, or frecency-jump anywhere

# Dev
gt  nvc  dots           # lazygit TUI, edit nvim config, edit this repo

# Docker
d  db  dc  de  dps  ds  # docker, buildx build, compose, exec, ps, stop+rm

# Kubernetes
k   kc   kn                           # kubectl, kubie ctx, kubie ns
kge kgn  kgns  kgp  kgpw  kgs        # get events/nodes/ns/pods/pods-watch/services

# Git
ga  gd  gs  gll  gls   # add, diff, status, pretty log, log navigator

# Custom tools
bin/commit              # interactive conventional commit helper (asks for type+message)
bin/git-clone URL       # clone → ~/projects/<host>/<user>/<repo>/
sudo bin/vpn-fix        # fix VPN DNS + routes (run with sudo)
bin/obsidian-sync       # sync your Obsidian vault
```

**Branch prefix = commit type**: branches named `feat/xxx` → `feat:` commits,
`fix/xxx` → `fix:`, `docs/xxx` → `docs:` — the `bin/commit` tool picks this up automatically.

## Troubleshooting

| Issue                        | Fix                                                                                   |
| ---------------------------- | ------------------------------------------------------------------------------------- |
| Missing core dependency      | Install `git` / `curl` via system package manager                                     |
| GNU Stow not installed       | `brew install stow` / `apt install stow` / `pacman -S stow`                           |
| Permission denied            | Run as non-root user with sudo access                                                 |
| OS not supported             | Check supported distros above                                                         |
| Stow conflicts               | Run `./setup.sh --dry-run install` to preview what changes, then `stow -v .` to apply |
| Zsh keybindings stop working | Known async bug — fixed in current config. Open a new terminal session.               |

```bash
pre-commit install && pre-commit run -a   # run all quality hooks
stow -nv .                                # dry-run stow
bash -n script.sh                         # syntax-check a script
```

**Pre-commit hooks**: shellcheck · yamllint · markdown-link-check · markdownlint-cli2 · detect-private-key ·
check-added-large-files · check-executables-have-shebangs · check-merge-conflict · check-symlinks

## Related Documentation

- [Try with docker](docker.md)
- [Contributing Guide](../CONTRIBUTING.md)
- [Code of Conduct](CODE_OF_CONDUCT.md)

## Contributing

[Contributing Guide](../CONTRIBUTING.md) • [Code of Conduct](CODE_OF_CONDUCT.md)
