#!/usr/bin/env bash
##########################################################
# Description: setup dotfiles @ new machine (Cross-Platform)
# Author: https://github.com/pablon
# Compatibility: Linux & macOS (Bash 3.2+)
# Usage: ./setup.sh [install|update|--help|--dry-run]
##########################################################

# 1. Set Execution Mode and IFS
set -euo pipefail
IFS=$'\n\t'

# 2. Force UTF-8 locale for consistent string parsing
export LC_ALL=C
export LANG=C
# export LC_ALL=en_US.UTF-8 2>/dev/null || export LC_ALL=C
# export LANG=en_US.UTF-8 2>/dev/null || export LANG=C

# 3. Context & Path Definitions
export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="${SCRIPT_DIR}"
export SETUP_DIR="${DOTFILES_DIR}/setup"
export FUNCTIONS_FILE="${SETUP_DIR}/.functions"

# 4. Source Library (Safely)
if [ -f "${FUNCTIONS_FILE}" ]; then
  set +u # Allow unbound variables in legacy functions
  # shellcheck disable=SC1090
  source "${FUNCTIONS_FILE}"
  set -u
else
  echo -e "\n==> ✘ ERROR: Library ${FUNCTIONS_FILE} not found.\n" >&2
  exit 1
fi

# 5. Verify user id
if [[ "$(id -u)" -eq "0" ]]; then
  _error "You must run this script as a non-root user. Bye"
  exit 1
fi

# --- ARGUMENT PARSING ---

MODE="install"
DRY_RUN=false

usage() {
  echo -e "${CYAN}Usage:${NC} $(basename "$0") [command] [options]

${STRONG}Commands:${NC}
  install       Full setup for a new machine (default)
  update        Pull latest changes, re-link, update plugins

${STRONG}Options:${NC}
  --dry-run     Preview changes without modifying anything
  --help, -h    Show this help message
"
}

while [[ $# -gt 0 ]]; do
  case "${1}" in
  install)
    MODE="install"
    shift
    ;;
  update)
    MODE="update"
    shift
    ;;
  --dry-run)
    DRY_RUN=true
    shift
    ;;
  --help | -h)
    usage
    exit 0
    ;;
  *)
    _error "Unknown argument: ${1}"
    usage
    exit 1
    ;;
  esac
done

# --- BANNER ---

echo -e "${YELLOW}
         __      __  _____ __
    ____/ /___  / /_/ __(_) /__  _____
   / __  / __ \\/ __/ /_/ / / _ \\/ ___/
  / /_/ / /_/ / /_/ __/ / /  __(__  )
  \\__,_/\\____/\\__/_/ /_/_/\\___/____/

  Cross-platform dotfiles setup ${CYAN}[${MODE}]
  ${CYAN}https://github.com/pablon/dotfiles${NC}
"

# --- SHARED FUNCTIONS ---

# Backup and remove a conflicting file/symlink before stow
backup_conflict() {
  local target="${1}"
  local full_path="${HOME}/${target}"
  local backup_path="${full_path}.$(date +%Y%m%d-%H%M%S)"

  if [ -L "${full_path}" ]; then
    # Dangling or stale symlink — just remove
    unlink "${full_path}" && _info "Removed stale symlink: ${CYAN}${target}"
  elif [ -e "${full_path}" ]; then
    # Real file/dir — back it up
    mv -f "${full_path}" "${backup_path}" && _info "Backed up: ${CYAN}${target}${NC} → ${backup_path}"
  fi
}

# Resolve stow conflicts from dry-run output and back them up
resolve_stow_conflicts() {
  local stow_output
  stow_output="$(cd "${DOTFILES_DIR}/" && stow -nv . 2>&1)" || true

  echo "${stow_output}" |
    awk '/neither a link nor a directory|existing target is not owned by stow/ {
      # extract the relative path from the conflict line
      for (i=1; i<=NF; i++) {
        if ($i ~ /^(\.|\w)/ && $i !~ /^(cannot|existing|since|neither|stow|is|not|a|link|nor|directory|and|owned|by|target|over|dotfiles)/) {
          gsub(/^dotfiles\//, "", $i)
          print $i
          break
        }
      }
    }' | while read -r conflict; do
    [ -n "${conflict}" ] && backup_conflict "${conflict}"
  done
}

update_zsh_plugins() {
  local ZSH_PLUGINS=(
    'marlonrichert/zsh-autocomplete'
    'zsh-users/zsh-autosuggestions'
    'zsh-users/zsh-syntax-highlighting'
    'MichaelAquilina/zsh-you-should-use'
  )

  [ -d "${HOME}/.zsh" ] || mkdir -p "${HOME}/.zsh"

  for plugin in "${ZSH_PLUGINS[@]}"; do
    local plugin_name
    plugin_name="$(basename "${plugin}")"
    if [ -d "${HOME}/.zsh/${plugin_name}" ]; then
      _info "Updating zsh plugin: ${YELLOW}${plugin_name}"
      (cd "${HOME}/.zsh/${plugin_name}/" && git pull --rebase 2>/dev/null) || true
    else
      _info "Cloning zsh plugin: ${CYAN}${plugin_name}"
      (cd "${HOME}/.zsh/" && git clone "https://github.com/${plugin}.git" 2>/dev/null) || true
    fi
  done
}

update_tmux_plugins() {
  local TPM_DIR="${HOME}/.tmux/plugins/tpm"

  if [ -d "${TPM_DIR}" ]; then
    _info "Updating tmux plugins via TPM"
    # Update TPM itself first
    (cd "${TPM_DIR}" && git pull --rebase 2>/dev/null) || true
    # Update all plugins
    "${TPM_DIR}/bin/update_plugins" all 2>/dev/null || true
  else
    _info "Installing TPM and tmux plugins"
    mkdir -p "${HOME}/.tmux/plugins"
    git clone "https://github.com/tmux-plugins/tpm" "${TPM_DIR}" 2>/dev/null || true
    "${TPM_DIR}/bin/install_plugins" 2>/dev/null || true
  fi
}

# --- MIGRATION CHECKS ---

# Migrate .zshrc_custom → .zshrc_base (introduced 2026-03-13, commit bc2b935)
# The repo renamed .zshrc_custom to .zshrc_base. Users who pull will have a
# dangling symlink at ~/.zshrc_custom pointing into the repo where the file
# no longer exists. We detect this and create a fresh user-owned ~/.zshrc_custom.
migrate_zshrc_custom() {
  local custom_link="${HOME}/.zshrc_custom"

  # Case 1: dangling symlink pointing into dotfiles (the file was renamed in repo)
  if [ -L "${custom_link}" ] && [ ! -e "${custom_link}" ]; then
    local link_target
    link_target="$(readlink "${custom_link}" 2>/dev/null || true)"
    if [[ "${link_target}" == *"dotfiles"* ]] || [[ "${link_target}" == *".zshrc_custom"* ]]; then
      _info "Migrating dangling .zshrc_custom symlink"
      unlink "${custom_link}"
      echo -e "# Add your zsh customizations here.\n# This file is sourced automatically when you start a new shell session.\n" >"${custom_link}"
      _success ".zshrc_custom migrated. Add your customizations to ${CYAN}${custom_link}"
    fi
  # Case 2: symlink still points to valid file in repo (old clone, not yet pulled)
  elif [ -L "${custom_link}" ]; then
    local link_target
    link_target="$(readlink "${custom_link}" 2>/dev/null || true)"
    if [[ "${link_target}" == *"dotfiles/.zshrc_custom"* ]]; then
      local backup="${custom_link}.backup-$(date +%Y%m%d-%H%M%S)"
      cp -f "${custom_link}" "${backup}" 2>/dev/null || true
      unlink "${custom_link}"
      echo -e "# Add your zsh customizations here.\n# This file is sourced automatically when you start a new shell session.\n" >"${custom_link}"
      _success ".zshrc_custom migrated. Your old config backed up to ${CYAN}${backup}"
    fi
  fi
  # Case 3: regular file (user-owned) — leave it alone, nothing to do
}

# --- REQUIRED DEPENDENCIES ---

check_dependencies() {
  local deps=(curl sudo jq stow)
  local deps_missing=()

  for dep in "${deps[@]}"; do
    if ! command -v "${dep}" &>/dev/null; then
      deps_missing+=("${dep}")
    fi
  done

  if [ "${#deps_missing[@]}" -gt "0" ]; then
    # _warning "Installing [${#deps_missing[@]}] missing requirements:${MAGENTA} ${deps_missing[*]}"
    _warning "Installing [${#deps_missing[@]}] missing requirements:${MAGENTA} $(echo "${deps_missing[@]}")"
    install_pkg_"${OS}" "${deps_missing[@]}" || exit 1
  fi
}

# --- STOW LINK ---

stow_link() {
  if [ "${DRY_RUN}" = true ]; then
    _info "[DRY-RUN] Stow would create these links:"
    (cd "${DOTFILES_DIR}/" && stow -nv .) || true
  else
    _info "Resolving stow conflicts..."
    resolve_stow_conflicts
    _info "Applying stow links (restow)..."
    if (cd "${DOTFILES_DIR}/" && stow -v --restow .); then
      _success "Stow links applied"
    else
      _warning "Stow completed with warnings — review output above"
    fi
  fi
}

# --- INSTALL MODE ---

run_install() {
  check_dependencies
  migrate_zshrc_custom

  # Run all setup scripts
  if [ -d "${SETUP_DIR}" ]; then
    _info "Running setup scripts from ${SETUP_DIR}"
    for script in "${SETUP_DIR}"/*.sh; do
      local script_name
      script_name="$(basename "${script}")"

      if [ "${DRY_RUN}" = true ]; then
        _info "[DRY-RUN] Would run: ${GREEN}${script_name}"
        continue
      fi

      _info "Running script: ${GREEN}${script_name}"
      # Subshell for isolation
      if (cd "${SETUP_DIR}/" && bash "${script_name}"); then
        _success "${script_name} Done"
      else
        _warning "${script_name} finished with errors (RC=$?)"
      fi
    done
  fi

  stow_link

  # Import shell history into atuin
  if [ "${DRY_RUN}" = false ]; then
    _info "[atuin] Importing existing shell history"
    export PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${HOME}/.atuin/bin:${PATH}"
    for shell in bash zsh; do
      atuin import "${shell}" 2>/dev/null || true
    done
  fi
}

# --- UPDATE MODE ---

run_update() {
  # Pull latest changes
  _info "Pulling latest changes..."
  if [ "${DRY_RUN}" = true ]; then
    _info "[DRY-RUN] Would run: git pull --rebase"
  else
    if (cd "${DOTFILES_DIR}" && git pull --rebase); then
      _success "Repository updated"
    else
      _error "git pull failed — resolve conflicts manually and re-run"
      exit 1
    fi
  fi

  check_dependencies
  migrate_zshrc_custom
  stow_link

  _info "Updating plugins..."
  if [ "${DRY_RUN}" = true ]; then
    _info "[DRY-RUN] Would update zsh plugins in ~/.zsh/"
    _info "[DRY-RUN] Would update tmux plugins via TPM"
  else
    update_zsh_plugins
    update_tmux_plugins
  fi
}

# --- MAIN ---

case "${MODE}" in
install) run_install ;;
update) run_update ;;
esac

if [ "${DRY_RUN}" = false ]; then
  divider
  _success "Dotfiles ${MODE} complete!"
  _success "Action required: ${YELLOW}logout or open a new terminal session to apply changes"
fi
divider
