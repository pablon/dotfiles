#!/usr/bin/env bash
##########################################################
# Description: setup dotfiles @ new machine (Cross-Platform)
# Author: https://github.com/pablon
# Compatibility: Linux & macOS (Bash 3.2+)
##########################################################

# 1. Set Execution Mode and IFS
set -aeuo pipefail
IFS=$'\n\t'

# 2. Force standard locale for consistent string parsing
export LC_ALL=C
export LANG=C

# 3. Context & Path Definitions
# Robust way to find script directory in Bash 3.2+ without realpath dependency
export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="${SCRIPT_DIR}"
export SETUP_DIR="${DOTFILES_DIR}/setup"
export FUNCTIONS_FILE="${SETUP_DIR}/.functions"

# 4. Source Library (Safely)
if [ -f "${FUNCTIONS_FILE}" ]; then
  set +u # Allow unbound variables in legacy functions
  source "${FUNCTIONS_FILE}"
  set -u
else
  _error "Library ${FUNCTIONS_FILE} not found."
  exit 1
fi

# 5. Verify user id
if [[ "$(id -u)" -eq "0" ]]; then
  echo -e "\n==> ✘ ERROR: You must run this script as a non-root user. Bye\n"
else
  echo -e "${YELLOW}
           __      __  _____ __
      ____/ /___  / /_/ __(_) /__  _____
     / __  / __ \\/ __/ /_/ / / _ \\/ ___/
    / /_/ / /_/ / /_/ __/ / /  __(__  )
    \\__,_/\\____/\\__/_/ /_/_/\\___/____/

    Cross-platform dotfiles setup
    ${CYAN}https://github.com/pablon/dotfiles${NC}\n"
fi

# 6. Required dependencies
deps=(bc curl sudo jq stow)
deps_missing=()
for dep in "${deps[@]}"; do
  if (! command -v "${dep}" &>/dev/null); then
    deps_missing+=("$dep")
  fi
  unset dep
done
if [ "${#deps_missing[@]}" -gt "0" ]; then
  _warning "Installing [${#deps_missing[@]}] missing requirements:${MAGENTA} $(echo "${deps_missing[@]}")"
  install_pkg_${OS} "${deps_missing[@]}" || exit 1
fi
unset deps deps_missing

# --- MAIN EXECUTION ---

# PHASE 1: Run Setup Scripts
if [ -d "${SETUP_DIR}" ]; then
  divider
  _info "Running setup scripts from ${SETUP_DIR}"
  for script in "${SETUP_DIR}"/*.sh; do
    script_name="$(basename "$script")"
    divider
    _info "Running script: ${GREEN}${script_name}"
    # Subshell for isolation
    (cd "${SETUP_DIR}/" && bash "${script_name}")

    if [ "${?}" -eq "0" ]; then
      _success "${script_name} Done"
    else
      _warning "${script_name} Done (rc=$?)"
    fi
  done
fi

# PHASE 2: Stow Backup
STOW_VER="$(stow --version | awk '{print $NF}')"
STOW_VER="${STOW_VER%.*}"
(
  cd "${DOTFILES_DIR}/" || exit
  divider
  _info "Backing up conflicts"
  if [ 1 -eq "$(echo "${STOW_VER} > 2.3" | bc)" ]; then
    (cd "${DOTFILES_DIR}/" && stow -nv . 2>&1) |
      awk '/neither a link nor a directory|existing target is not owned by stow/ {print $8}' | while read -r i; do
      mv -vf ${HOME}/${i}{,.$(date +%Y%m%d-%H%M%S)}
    done
  else
    (cd "${DOTFILES_DIR}/" && stow -nv . 2>&1) |
      awk '/neither a link nor a directory|existing target is not owned by stow/ {print $NF}' | while read -r i; do
      mv -vf ${HOME}/${i}{,.$(date +%Y%m%d-%H%M%S)}
    done
  fi
)

# PHASE 3: Stow Smart Link
divider
_info "Applying stow links..."
(cd "${DOTFILES_DIR}/" && stow -v .)

# PHASE 5: import existing shell history
if [ "${?}" -eq "0" ]; then
  _info "[atuin] Importing existing shell history"
  export PATH="${ASDF_DATA_DIR:-${HOME}/.asdf}/shims:${HOME}/.atuin/bin:${PATH}"
  for shell in bash zsh; do
    atuin import ${shell} 2>/dev/null || true
  done
fi

divider
_success "Dotfiles setup complete!"
divider
_success "Action required: ${YELLOW}logout/login again"
divider
