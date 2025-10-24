#!/usr/bin/env bash
##########################################################
# Description: Install lazyvim
# Author: https://github.com/pablon
##########################################################

source "$(dirname "${0}")/.functions" || exit 1

(type nvim &>/dev/null) || install_pkg_${OS} nvim

# Make a backup of your current Neovim files:
(
  # required
  mv ~/.config/nvim{,.bak}
  # optional but recommended
  mv ~/.local/share/nvim{,.bak}
  mv ~/.local/state/nvim{,.bak}
  mv ~/.cache/nvim{,.bak}
) &>/dev/null

# Clone the starter from https://www.lazyvim.org/
git clone https://github.com/LazyVim/starter ~/.config/nvim || exit 1

# Remove the .git folder, so you can add it to your own repo later
rm -rf ~/.config/nvim/.git

# Verify
nvim --version

_success "Done ${0}"
