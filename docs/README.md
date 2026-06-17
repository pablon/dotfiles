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
mkdir -p ~/.kube/configs  # place cluster configs here
```

More languages via ASDF

```sh
asdf plugin add nodejs &&
  asdf install nodejs latest &&
  asdf -u nodejs latest
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
- **Tmux** (`.tmux.conf`): see below

## Neovim

Built on [LazyVim](https://www.lazyvim.org), which means you get a polished IDE experience out of the box — LSP,
treesitter, autocompletion, snippet engine, and a sane keymap layer — without maintaining 200 lines of boilerplate.
Every plugin and option on top is deliberate: no toy plugins, no abandonware.

### Editing that stays out of your way

**Snacks.nvim** is the workhorse — it powers the dashboard, file picker, live grep, file explorer, and git status
browser, all under the `<leader>` prefix. No startup delay, no external dependencies.

**Markdown is a first-class citizen.** Not just syntax highlighting: `render-markdown.nvim` renders headings,
checkboxes, callouts, and code blocks inline, so what you see is what you get. Live preview in the browser
(`<leader>mp`) for when you need to check the final look, and `markdown-toc.nvim` inserts a linked table of contents
(`<leader>mti`).

**Folding that actually works for writing.** Custom fold keymaps (`zi`, `zj`, `zk`, `zl`, `z;`) let you collapse
headings by level — fold everything from H1 down, or only H3+ — without memorizing obscure `z` commands. Press `zu` to
unfold all and reload.

**Obsidian vault management** is fully integrated. `obsidian.nvim` lets you search notes, follow `[[wiki links]]`,
manage daily notes, toggle checkboxes, extract text into new notes, and open the Obsidian app — all mapped under
`<leader>o`:

| Key           | Action                          |
| ------------- | ------------------------------- |
| `<leader>oo`  | Open note in Obsidian app       |
| `<leader>oss` | Search all vault notes          |
| `<leader>onn` | Create new note                 |
| `<leader>od`  | Insert daily note               |
| `<leader>ob`  | Show backlinks picker           |
| `<leader>of`  | Follow `[[wiki link]]` in split |
| `<leader>ost` | Search by tags                  |

### Git in the editor, not just in the terminal

**Gitsigns** adds blame, hunk navigation, staging, and diff previews to the sign column — you see what changed before
you commit, without leaving the buffer. Combined with **Lazygit** in a tmux popup (`C-g`), you get a full Git workflow
without leaving your editor.

### AI, but on your terms

[**Copilot**](https://github.com/zbirenbaum/copilot.lua) runs as a pure Lua client — lightweight, no telemetry, no
Electron. Completion can be toggled on/off with `<leader>p`/`<leader>P` (useful when tab is for snippets, not AI
guesses).

[**opencode.nvim**](https://github.com/NickvanDyke/opencode.nvim) adds agentic AI assistance — research, code reviews,
explanations, and inline prompts — all aware of your editor context.

### Built for ops and infra work

Not every Neovim config handles Helm charts, Ansible playbooks, and encrypted SOPS files. This one does:

- **Helm**: syntax highlighting via `vim-helm`, LSP via `helm_ls` (configured in `helm.lua`)
- **Ansible**: playbook utilities, filetype detection
- **SOPS**: encrypt/decrypt secrets in-editor with `nvim-sops`
- **Jinja**: `*.j2` files get correct syntax highlighting
- **Gitconfig**: `gitconfig-*` patterns detected automatically

### The rest that matters

| Feature              | What it does                                                                                    |
| -------------------- | ----------------------------------------------------------------------------------------------- |
| **incline.nvim**     | Floating filename label on every window — no more guessing which buffer you're in               |
| **goto-preview**     | LSP definitions, references, and implementations in a floating popup instead of jumping buffers |
| **undotree**         | Visual undo history tree — browse and restore any previous state                                |
| **vim-visual-multi** | Multiple cursors and selections, Sublime-Text style                                             |
| **text-case.nvim**   | Convert between camelCase, snake_case, kebab-case, Title Case, and more                         |
| **icon-picker.nvim** | Fuzzy-find and insert Nerd Font icons, emojis, and symbols                                      |
| **vim-easy-align**   | Align text by any character (`<leader>al`)                                                      |
| **screenkey.nvim**   | Show pressed keys in a floating window — useful for demos and screencasts                       |
| **veil.nvim**        | Hide secrets and sensitive content before screen sharing                                        |

### Trying it

Kick it with:

```bash
nvim .
```

That's it. The config symlinks via Stow, LazyVim auto-installs all plugins on first launch, and the full plugin roster
lives in [`lua/plugins/README.md`](.config/nvim/lua/plugins/README.md).

## Tmux

This is not your default tmux. The config is designed to make tmux feel like a natural extension of your terminal — not
an extra layer you tolerate.

### What makes it different

**Catppuccin Mocha top to bottom**: status bar, pane borders, window tabs, popups — all themed with the same palette as
the rest of the dotfiles. The status bar sits **at the top** (macOS-style) and shows: session name, current path, active
command, battery level, and clock.

**C-a prefix**: remapped from the awkward `C-b` to `C-a`. Your right pinky thanks you.

**Popups for everything** — the feature you didn't know you needed:

| Key   | What opens                                                                         |
| ----- | ---------------------------------------------------------------------------------- |
| `C-g` | Lazygit, right where you are                                                       |
| `C-t` | htop                                                                               |
| `C-v` | Neovim in the current dir                                                          |
| `C-p` | Floating scratch terminal (via [tmux-floax](https://github.com/omerxx/tmux-floax)) |

**Config menu** — press `C-b d` (prefix + `d`) to get a menu that lets you edit aliases, exports, zshrc, tmux.conf,
nvim, ghostty, starship — all in popups, no file hunting.

### Smart defaults that save time

- **Pane splits** inherit the current working directory — no more `cd` after splitting
- **Vi mode keys** in copy mode, mouse selection copies without exiting copy mode
- **History** bumped to 10,000 lines, escape-time set to 0 (no delay after Escape)
- **Windows renumber** automatically when you close one (no gaps)
- **Clipboard** syncs with the system clipboard — no `Shift+Select` dance

### Self-healing plugins

On first run, [TPM (Tmux Plugin Manager)](https://github.com/tmux-plugins/tpm) installs itself and all plugins
automatically — zero manual steps. Active plugins:

| Plugin                                                           | What it does                                                       |
| ---------------------------------------------------------------- | ------------------------------------------------------------------ |
| [tmux-resurrect](https://github.com/tmux-plugins/tmux-resurrect) | Save and restore sessions, windows, and pane layout across reboots |
| [tmux-fzf-url](https://github.com/wfxr/tmux-fzf-url)             | Press `u`, pick a URL from the terminal history, open in browser   |
| [tmux-fzf](https://github.com/sainnhe/tmux-fzf)                  | Fuzzy-find sessions, windows, panes, commands, and key bindings    |
| [tmux-battery](https://github.com/tmux-plugins/tmux-battery)     | Battery percentage and icon in the status bar                      |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible)   | Sanity-defaults for cursor, searching, and UTF-8                   |
| [tmux-yank](https://github.com/tmux-plugins/tmux-yank)           | System clipboard integration on macOS and Linux                    |
| [tmux-floax](https://github.com/omerxx/tmux-floax)               | Floating scratch terminal with `C-p`                               |

### Start using it

There's nothing to install besides `tmux` itself — the config symlinks via Stow and bootstraps everything on first
`tmux` launch.

## Aliases & Tools

These are the main shortcuts you get after setup. The full list lives in `.aliases` (auto-sourced by Zsh). Type the
alias directly in your terminal — no prefix needed.

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

**Branch prefix = commit type**: branches named `feat/xxx` → `feat:` commits, `fix/xxx` → `fix:`, `docs/xxx` → `docs:` —
the `bin/commit` tool picks this up automatically.

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
