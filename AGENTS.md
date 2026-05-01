# Dotfiles | GNU Stow | Bash | Lua | macOS+Linux

Cross-platform dotfiles. No build/test — quality via pre-commit hooks.

## COMMANDS

| Action      | Command                                                                        |
| ----------- | ------------------------------------------------------------------------------ |
| Fresh setup | `./setup.sh`                                                                   |
| Stow link   | `stow -v .` (dry-run: `stow -nv .`)                                            |
| All hooks   | `pre-commit run -a`                                                            |
| Shellcheck  | `shellcheck --severity=error script.sh`                                        |
| Yamllint    | `yamllint -d "{extends: relaxed, rules: {line-length: {max: 500}}}" file.yaml` |
| Format Lua  | `stylua --config-path=.config/nvim/stylua.toml .config/nvim/`                  |
| Nvim health | `nvim -c 'checkhealth'`                                                        |

## STRUCTURE

```
setup.sh              # Main orchestrator
setup/
  .functions          # Shared utilities (source in ALL scripts)
  0_*.sh - 8_*.sh     # Numbered phases
  pkglist.{brew,apt,pacman,dnf,asdf}
bin/{commit,git-clone,vpn-fix,obsidian-sync,...}
.config/{nvim,starship,lazygit,k9s,gh-dash,atuin,bat,gh,ghostty,yazi}
.zshrc                # Orchestrator: plugin loader, skip list, atuin/starship/direnv init
.zshrc_base           # All zsh config: history, PATH, FPATH, fzf, completions
```

## ZSH PLUGIN CONFIG

Load order: `.zshrc` plugins → `.zshrc_base` → `.zshrc_custom` → atuin → starship → direnv.

**zsh-autocomplete**: async enabled, PR #856 FD leak fix applied locally at `~/.zsh/zsh-autocomplete/Functions/Init/.autocomplete__async`. When PR merges upstream, `git pull` replaces patch.

**zsh-autosuggestions**: TEMPORARILY RE-ENABLED (skip line commented out in `.zshrc`). Known segfault risk via issue #725 in `complist.so`. If crashes appear, restore `ZSH_PLUGINS_SKIP=(zsh-autosuggestions)` in `.zshrc` and consult `_zsh-fixes.md` in Obsidian vault.

**fzf + autocomplete Tab coexistence**: fzf saves `$fzf_default_completion=complete-word` at init. `**<Tab>` → fzf fuzzy; `<Tab>` → autocomplete's `complete-word` (replaced in precmd via `zle -C`).

Config lives in `.zshrc_base` (NOT `.zshrc`). `.zshrc` is a thin orchestrator only.

## PRE-COMMIT HOOKS

See `.pre-commit-config.yaml`. Active: shellcheck (error), yamllint (relaxed, 500 char), markdown-link-check, markdownlint-cli2, detect-private-key, check-added-large-files, check-executables-have-shebangs, check-merge-conflict, check-symlinks, destroyed-symlinks, fix-byte-order-marker, double-quote-string-fixer, mixed-line-ending, trailing-whitespace, end-of-file-fixer.

## SHELL TEMPLATE

```bash
#!/usr/bin/env bash
# Description / Author / Compatibility (Bash 3.2+)
set -euo pipefail
source "$(dirname "${0}")/.functions" || exit 1
main() { ... }
main "$@"
```

## LUA TEMPLATE

```lua
---@module 'plugin_name'
---@type PluginSpec
return {
  "author/plugin",
  opts = function(_, opts) end,
}
```

## OS DETECTION

```bash
source "$(dirname "${0}")/.functions"
detect_os  # Sets $OS: darwin|debian|ubuntu|arch|fedora|rocky|almalinux
case "$OS" in
  "darwin") brew install pkg ;;
  "debian") sudo apt install pkg ;;
  *) _error "Unsupported: $OS" ;;
esac
```

## OUTPUT FUNCTIONS

`_info` (cyan) | `_success` (green) | `_error` (red, exits)

## CODE STYLE

| Type            | Convention                                                |
| --------------- | --------------------------------------------------------- |
| Exported/Global | `UPPERCASE_UNDERSCORES`                                   |
| Locals/funcs    | `lowercase_underscores`                                   |
| Quote vars      | `"${VAR}"` always; `"${VAR:-default}"`                    |
| Lua             | 2-space indent, 120 char (see `.config/nvim/stylua.toml`) |
| YAML            | 2-space indent, max 500 chars                             |

## ERROR HANDLING

```bash
command -v tool >/dev/null 2>&1 || _error "tool not installed"
mkdir -p "${DIR}" || _error "Failed"
```

```lua
local ok, result = pcall(require, 'module')
if not ok then vim.notify('Failed: '..result, vim.log.levels.ERROR) end
```

## GIT

Use `bin/commit` (interactive, auto-detects type from branch prefix: `feat/`→`feat:`, `fix/`→`fix:`, `docs/`→`docs:`). Conventional Commits.

## ADDING PACKAGES

1. Add to `setup/pkglist.<manager>`
2. Custom logic → edit `setup/1_packages.sh` with `detect_os` case

## ANTI-PATTERNS

| Don't                       | Do                          |
| --------------------------- | --------------------------- |
| `echo $HOME`                | `echo "${HOME}"`            |
| Missing `set -euo pipefail` | Always include              |
| Raw `echo` for status       | `_info`/`_success`/`_error` |
| Hardcoded OS logic          | `detect_os` + case          |
| Commit secrets              | Env vars; hooks block keys  |

## SECURITY

Never commit secrets. Pre-commit blocks private keys + large files. Scripts: `chmod 0755`.
