# Dotfiles Documentation

This repo manages my shell, editor, and terminal configs across macOS and Linux. Run `setup.sh` on a fresh machine and
it installs everything: packages, dotfiles, Zsh plugins, Neovim, Docker, Kubernetes CLIs, and more — all in one shot.

## Scope

This page covers the repository layout, setup flow, and key configuration notes. It does **not** duplicate every detail
from each config file — check the file itself or the [Contributing Guide](../CONTRIBUTING.md) for deeper dives.

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
It uses [GNU Stow](https://www.gnu.org/software/stow/) to symlink config files from this repo into your home directory —
no copying, no manual moves. If a target file already exists, Stow backs it up with a timestamp (`*.YYYYMMDD-HHMMSS`)
before replacing it.
Every script runs in Strict Mode (`set -euo pipefail`), auto-detects your OS (macOS → Homebrew, Debian → APT, Arch →
Pacman, Fedora → DNF), and runs numbered phases in order.

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

Kubernetes contexts

```sh
~/.kube/configs  # place cluster configs here, kubie will pick'em up
```

More languages via ASDF

```sh
asdf plugin add nodejs && asdf install nodejs latest && asdf -u nodejs latest
# try also asdf shell functions
asdf_install
asdf_uninstall
asdf_remove
asdf_upgrade
```

Git identity

```sh
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
git config --global user.signingkey ~/.ssh/id_ed25519.pub
```

> [!TIP]
> Add the following block **at the beginning** of your `~/.gitconfig` if you
> want to get advantage of all pre-cooked git configs, aliases and functions:
>
> ```gitconfig
> [include]
>   path = ~/dotfiles/.gitconfig
> ```

**Required** shell config files sourced automatically by `.zshrc`:

> [!IMPORTANT]
> **NEVER EDIT THESE**:

| File            | Purpose                                |
| --------------- | -------------------------------------- |
| `~/.aliases`    | Main aliases (managed by Stow)         |
| `~/.functions`  | Main shell functions (managed by Stow) |
| `~/.zshrc_base` | Extended Zsh config (managed by Stow)  |

**User-owned** shell config files sourced automatically by `.zshrc_base` if they exist (never commited):

> [!TIP]
> **ALL your customizations go here**:

| File                  | Purpose                                                                      |
| --------------------- | ---------------------------------------------------------------------------- |
| `~/.aliases_custom`   | Override or extend aliases without editing `~/.aliases`                      |
| `~/.aliases_work`     | Work-specific aliases (just to keep them separated from `~/.aliases_custom`) |
| `~/.completions/`     | Custom completion scripts directory (added to `FPATH` via `~/.zshrc`)        |
| `~/.exports`          | Additional environment variables                                             |
| `~/.functions_custom` | Override or extend functions without editing `~/.functions`                  |
| `~/.secrets`          | Secrets and API keys (chmod 0600 recommended)                                |
| `~/.tmux_custom.conf` | Override tmux keybindings and options without editing `~/.tmux.conf`         |
| `~/.zshrc_custom`     | Override or extend functions without editing `~/.zshrc`                      |

### Maintenance

```bash
./setup.sh update --dry-run              # preview update without changes
./setup.sh update                        # pull + re-link + update plugins

( cd ~/dotfiles && stow -v . )           # re-link only (manual)

( cd ~/dotfiles && stow -vD . )          # unlink all
rm -rf ~/dotfiles                        # full removal
```

## Repository Structure

```text
~/dotfiles/
├── .aliases / .functions / .gitconfig / .tmux.conf / .vimrc
├── .zshrc            # plugin loader & orchestrator
├── .zshrc_base       # all zsh config: PATH, FPATH, fzf, completions
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

- **Neovim** (`nvim/`): see below
- **Git** (`.gitconfig`): GPG signing, `bin/commit` helper, custom aliases
- **Lazygit**: Delta diffs, Nerd Fonts v3, branch divergence indicators, auto-commit-prefix (Jira/Azure DevOps)
- **Kubernetes**: kubie context/namespace switching, kubecolor, helm docs generation
- **Herdr** (`.config/herdr/config.toml`): tmux-like terminal workspace with agent navigation and command panes
- **Tmux** (`.tmux.conf`): see below

## Neovim

Built on [LazyVim](https://www.lazyvim.org), so the editor starts with LSP, Treesitter, completion, snippets, and sane
defaults before any custom plugins are added. The extra layer focuses on daily work: fast navigation with Snacks.nvim,
Markdown and Obsidian workflows, Git signs and diffs, Copilot/opencode assistance, and infra-friendly filetypes such as
Helm, Ansible, SOPS, Jinja, and Git config files.

The config symlinks via Stow, LazyVim auto-installs plugins on first launch, and the canonical plugin roster lives in
[`lua/plugins/README.md`](../.config/nvim/lua/plugins/README.md).

## Tmux

This is not your default tmux. The config is designed to make tmux feel like a natural extension of your terminal — not
an extra layer you tolerate.

It uses `C-a` as the prefix. A minimalist top status bar. Splits inherit the current directory, copy mode uses vi keys,
10,000 history lines, windows renumber automatically, and clipboard integration works on macOS and Linux.

Common popups stay one shortcut away: `C-g` for Lazygit, `C-t` for htop, `C-v` for Neovim, and `C-p` for a floating
scratch terminal. TPM bootstraps itself on first launch, so opening `tmux` is enough after Stow links the config.

## Herdr

[Herdr](../.config/herdr/config.toml) is the newer terminal workspace configuration. It keeps tmux muscle memory while
adding agent-aware navigation and command panes.

- Prefix: `Ctrl+a`, matching the tmux prefix used in this repo.
- Workspaces and tabs: create, switch, rename, and pick workspaces from prefix-driven bindings.
- Panes: split vertically/horizontally, zoom, resize, swap, and navigate with tmux/vi-style keys.
- Agents: move through the sidebar with `prefix+Alt+j/k` or jump directly with `prefix+Ctrl+1..9`.
- Command panes: open Lazygit, Hunk diff/show, htop, or `nvim .` in the current directory.
- Session behavior: follow the current working directory, keep pane history, and resume agents on restore.

## Aliases & Tools

These are the main shortcuts you get after setup. The full list lives in `.aliases` (auto-sourced by Zsh). Type the
alias directly in your terminal — no prefix needed.

```bash
# Navigation — zoxide learns your habits, so `cd` gets smarter over time
..  ...  cd             # go up 1/2 dirs, or frecency-jump anywhere

# Docker
d  db  dc  de  dps  ds  # docker, buildx build, compose, exec, ps, stop+rm

# Kubernetes
k   kc   kn             # kubectl, kubie ctx, kubie ns
kge kgn  kgns  kgp  kgpw  kgs  # get events/nodes/ns/pods/pods-watch/services

# Git
ga  gd  gs  gll  gls gt # add, diff, status, pretty log, log navigator, lazygit

# Custom tools
bin/commit              # interactive conventional commit helper
bin/git-clone URL       # clone → ~/projects/<host>/<user>/<repo>/
sudo bin/vpn-fix        # fix VPN DNS + routes (run with sudo)
bin/obsidian-sync       # sync your Obsidian vault
```

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
