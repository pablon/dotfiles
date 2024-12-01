#!/usr/bin/env bash
##########################################################
# Description: setup dotfiles @ new machine
# Author: https://github.com/pablon
##########################################################

source "$(git rev-parse --show-toplevel)/setup/.functions" &>/dev/null

if [ -d ${HOME}/dotfiles ]; then
  # setup scripts
  (
    cd ${HOME}/dotfiles/setup/ || exit 1
    for f in *.sh; do
      _info "Running $f"
      bash "$f"
    done
  )
  # backup
  (cd ${HOME}/dotfiles/ && stow -nv . 2>&1) |
    awk '/neither a link nor a directory|existing target is not owned by stow/ {print $NF}' | while read i; do
    mv -vf ${HOME}/${i}{,.$(date +%Y%m%d-%H%M%S)}
  done
fi

# link
_info "Linking files"
(cd ${HOME}/dotfiles/ && stow -v .)

_info "Now reload your shell:\n\t${YELLOW}source ~/.zshrc\n"
