#!/usr/bin/env bash
##########################################################
# Description: setup dotfiles @ new machine (Cross-Platform)
# Author: https://github.com/pablon
# Compatibility: Linux & macOS (Bash 3.2+)
##########################################################

# 1. Set Execution Mode and IFS
set -a
IFS=$'\n\t'

# 2. Verify user id
if [[ "$(id -u)" -ne "0" ]]; then
	echo -e "\n==> Running as user '$(whoami)' ($(id -u))\n"
	export SUDO="sudo"
	sleep 2
else
	echo -e "\n==> ✘ ERROR: You must run this script as a non-root user. Bye\n"
	exit 1
fi

# 3. Force standard locale for consistent string parsing
export LC_ALL=C
export LANG=C

# 4. Context & Path Definitions
# Robust way to find script directory in Bash 3.2+ without realpath dependency
export SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="${SCRIPT_DIR}"
export SETUP_DIR="${DOTFILES_DIR}/setup"
export FUNCTIONS_FILE="${SETUP_DIR}/.functions"

# 5. Source Library (Safely)
if [ -f "${FUNCTIONS_FILE}" ]; then
	set +u # Allow unbound variables in legacy functions
	source "${FUNCTIONS_FILE}"
	set -u
else
	_error "Library ${FUNCTIONS_FILE} not found."
	exit 1
fi

# 6. Pre-flight Checks
if [ ! -d "${DOTFILES_DIR}" ]; then
	_error "Dotfiles directory not found at ${DOTFILES_DIR}"
	exit 1
fi

deps=("curl" "sudo" "jq" "stow")
for dep in "${deps[@]}"; do
	if ! command -v "${dep}" >/dev/null 2>&1; then
		_warning "Missing core dependency: ${dep}${NC} -- trying to install it.."
		install_pkg_${OS} ${dep} || exit 1
	fi
	unset dep
done
unset deps

# --- MAIN EXECUTION ---

# PHASE 1: Run Setup Scripts
if [ -d "${SETUP_DIR}" ]; then
	divider
	_info "Running setup scripts from ${SETUP_DIR}"
	for script in "${SETUP_DIR}"/*.sh; do
		script_name="$(basename "$script")"
		divider
		_info "Executing: ${GREEN}${script_name}"
		# Subshell for isolation
		(cd "${SETUP_DIR}/" && bash "${script_name}")

		if [ "${?}" -eq "0" ]; then
			_success "${script_name} exit code: $?"
		else
			_warning "${script_name} exit code: $?"
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
		atuin import ${shell}
	done
fi

divider
_success "Dotfiles setup complete!"
divider
_success "Action required: ${YELLOW}logout/login again"
divider
