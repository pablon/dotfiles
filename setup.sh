#!/usr/bin/env bash
##########################################################
# Description: setup dotfiles @ new machine (Cross-Platform)
# Author: https://github.com/pablon
# Compatibility: Linux & macOS (Bash 3.2+)
##########################################################

# 1. Strict Mode
set -euo pipefail
IFS=$'\n\t'

# Force standard locale for consistent string parsing
export LC_ALL=C

# 2. Context & Path Definitions
# Robust way to find script directory in Bash 3.2+ without realpath dependency
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="${SCRIPT_DIR}"
SETUP_DIR="${DOTFILES_DIR}/setup"
FUNCTIONS_FILE="${SETUP_DIR}/.functions"

# 3. Utilities
_log() { printf "${BLUE}==> %s${NONE}\n" "$1"; }
_warn() { printf "${YELLOW}==> WARNING: %s${NONE}\n" "$1"; }
_err() { printf "${RED}==> ERROR: %s${NONE}\n" "$1"; }

# Source Library (Safely)
if [ -f "${FUNCTIONS_FILE}" ]; then
	set +u # Allow unbound variables in legacy functions
	source "${FUNCTIONS_FILE}"
	set -u
else
	# Minimal fallback colors if functions file is missing
	BLUE='\033[1;34m' YELLOW='\033[1;33m' RED='\033[0;31m' GREEN='\033[0;32m' NONE='\033[0m'
	_err "Library ${FUNCTIONS_FILE} not found."
	exit 1
fi

# 4. Pre-flight Checks
check_env() {
	local deps=("git" "curl")
	for dep in "${deps[@]}"; do
		if ! command -v "$dep" >/dev/null 2>&1; then
			_err "Missing core dependency: $dep"
			exit 1
		fi
	done

	if [ ! -d "${DOTFILES_DIR}" ]; then
		_err "Dotfiles directory not found at ${DOTFILES_DIR}"
		exit 1
	fi
}

# --- MAIN EXECUTION ---

check_env

# PHASE 1: Run Setup Scripts
if [ -d "${SETUP_DIR}" ]; then
	divider
	_log "Running setup scripts from ${SETUP_DIR}"

	# Portable find + sort loop
	# Using process substitution compatible with Bash 3.2+
	while read -r script; do
		script_name=$(basename "$script")
		divider
		_info "Executing: ${GREEN}${script_name}"

		# Subshell for isolation
		(
			cd "${SETUP_DIR}" || exit 1
			if ! bash "$script"; then
				_err "Script ${script_name} failed."
				exit 1
			fi
		)
	done < <(find "${SETUP_DIR}" -maxdepth 1 -name "*.sh" -type f | sort)
fi

# PHASE 2: Check Stow
if ! command -v stow >/dev/null 2>&1; then
	_err "GNU Stow is not installed. Setup scripts failed to install it."
	exit 1
fi

# PHASE 3: Smart Link & Backup
(
	cd "${DOTFILES_DIR}" || exit 1
	divider
	_log "Backing up conflicts and linking files"

	# Capture stow dry-run errors to identify conflicts
	# We use a temporary file because pipes + set -e can be tricky with grep return codes
	TMP_ERR=$(mktemp)
	stow -nv -t "${HOME}" . 2>"${TMP_ERR}" >/dev/null || true

	# Parse conflicts manually to avoid regex compatibility issues in [[ ]] across bash versions
	# We use grep/sed which are standard posix/gnu utilities available on both platforms

	# Process the error log
	while read -r line; do
		file=""
		# Try to extract filename using sed for different stow version outputs

		# Case 1: "existing target is not owned by stow: .zshrc"
		if echo "$line" | grep -q "existing target is not owned by stow:"; then
			file=$(echo "$line" | sed 's/.*existing target is not owned by stow: //')
		# Case 2: "LINK: .zshrc => ... exists; neither a link nor a directory"
		elif echo "$line" | grep -q "neither a link nor a directory"; then
			file=$(echo "$line" | awk '{print $2}')
		fi

		if [ -n "$file" ]; then
			# Clean up filename (trim whitespace)
			file=$(echo "$file" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
			TARGET="${HOME}/${file}"

			if [ -e "${TARGET}" ]; then
				TIMESTAMP=$(date +%Y%m%d-%H%M%S)
				BACKUP="${TARGET}.backup-${TIMESTAMP}"
				_warn "Conflict: ${file} -> ${BACKUP}"

				mkdir -p "$(dirname "$BACKUP")"
				mv "${TARGET}" "${BACKUP}"
			fi
		fi
	done <"${TMP_ERR}"
	rm -f "${TMP_ERR}"

	# Apply Links
	divider
	_log "Applying stow links..."
	stow -v -t "${HOME}" .
)

_success "Dotfiles setup complete!"
_success "Action required: Reload your shell:\n\t${GREEN}source ~/.zshrc${NONE}"
