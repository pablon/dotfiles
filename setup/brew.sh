#!/usr/bin/env bash
##########################################################
# Description: Installs homebrew and required tools.
# Author: https://github.com/pablon
##########################################################
# Requires: curl
##########################################################

source "$(git rev-parse --show-toplevel)/setup/.functions" &>/dev/null

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

if [[ "$(uname)" == "Darwin" ]] && [[ "$(uname -m)" == "arm64" ]]; then
  if (! arch -x86_64 /usr/bin/true 2>/dev/null); then
    echo -e "${YELLOW}HEY! I've detected you're running an Apple Silicon Chip - ${CYAN}I will install Rosetta2 now${NONE}"
    sleep 2
    _info "Installing ${YELLOW}rosetta2"
    /usr/sbin/softwareupdate --install-rosetta --agree-to-license
    echo -e "/usr/sbin/softwareupdate --install-rosetta --agree-to-license${NONE} = ${YELLOW}$?${NONE}"
  fi
fi

#===============================================================
# Install Homebrew
if (command -v brew &>/dev/null) || [ "$(uname -m)" != "amd64" ]; then
  exit 0
else
  _info "Installing ${YELLOW}homebrew"
  NONINTERACTIVE=1 bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # verify
  if [ $? -ne 0 ] || (! command -v brew config &>/dev/null); then
    echo "❌ Something went wrong while installing homebrew. Aborting."
    exit 1
  fi
  # Disable brew analytics
  brew analytics off
fi

#===============================================================
# Install packages

if [ -r "${BREW_LEAVES}" ]; then
  _info "About to install $(wc -l "${BREW_LEAVES}" | awk '{print $1}') packages"
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

_success "Done ${0}"
