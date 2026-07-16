#!/usr/bin/env bash
##########################################################
# Description: Install lazyvim
# Author: https://github.com/pablon
##########################################################

set -aeuo pipefail

source "$(dirname "${0}")/.functions" || exit 1

if (! type nvim &>/dev/null); then
  install_pkg_${OS} nvim
fi

# Make a backup of your current Neovim files:
(
  # required
  mv -f ~/.config/nvim{,.bak}
  # optional but recommended
  mv -f ~/.local/share/nvim{,.bak}
  mv -f ~/.local/state/nvim{,.bak}
  mv -f ~/.cache/nvim{,.bak}
) &>/dev/null || true

# Verify
nvim --version | head -1
