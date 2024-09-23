#!/usr/bin/env bash
##########################################################
# Description: Installs homebrew and required tools.
# Author: https://github.com/pablon
##########################################################
# Requires: curl
##########################################################

if [[ "$(uname -s)" != "Darwin" ]]; then
	echo "This script is for macOS only"
	exit 0
fi

source ./.functions &>/dev/null

# taps: warrensbox/tap # tfswitch
# casks: homebrew/cask-fonts/font-powerline-symbols homebrew/cask-fonts/font-meslo-for-powerline

BREW_LEAVES="$(dirname "${0}")/brew.leaves"

# Colors:
BOLD="\033[1;37m"
YELLOW="\033[1;93m"
BLUE="\033[1;94m"
CYAN="\033[1;96m"
NONE="\033[0m"

#===============================================================
# Detect Apple Silicon chipset + install rosetta

if [[ "$(uname -s)" == "Darwin" ]] && [[ "$(uname -m)" == "arm64" ]]; then
	echo -e "${YELLOW}HEY! I've detected you're running an Apple Silicon Chip - ${CYAN}I will install Rosetta now${NONE}"
	sleep 2
	_banner "Installing ${YELLOW}rosetta"
	/usr/sbin/softwareupdate --install-rosetta --agree-to-license
	echo -e "/usr/sbin/softwareupdate --install-rosetta --agree-to-license${NONE} = ${YELLOW}$?${NONE}"
fi

#===============================================================
# Install Homebrew
if (! command -v brew &>/dev/null); then
	_banner "Installing ${YELLOW}homebrew"
	NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	# verify
	if ! (command -v brew config &>/dev/null); then
		echo "❌ Something went wrong while installing homebrew. Aborting."
		return 1
	fi
fi

# Disable brew analytics
brew analytics off

#===============================================================
# Install packages

if [ -r "${BREW_LEAVES}" ]; then
	_banner "About to install $(wc -l "${BREW_LEAVES}" | awk '{print $1}') packages"
	xargs brew install <"${BREW_LEAVES}"
fi

# docker-buildx is a Docker plugin. For Docker to find this plugin, symlink it:
if [ -x "/usr/local/opt/docker-buildx/bin/docker-buildx" ]; then
	if [ ! -d "${HOME}/.docker/cli-plugins" ]; then
		mkdir -p "${HOME}/.docker/cli-plugins"
		ln -sfn /usr/local/opt/docker-buildx/bin/docker-buildx "${HOME}/.docker/cli-plugins/docker-buildx"
	fi
fi

#===============================================================
# Cleanup
unset BREW_LEAVES
unset BOLD
unset YELLOW
unset BLUE
unset CYAN
unset NONE

echo "✅ Done ${0}"
