#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

set -euo pipefail

source "$(dirname "${0}")/.functions" || exit 1

ZSH_PLUGINS=(
  'marlonrichert/zsh-autocomplete'
  'zsh-users/zsh-autosuggestions'
  'zsh-users/zsh-syntax-highlighting'
)

if (! command -v zsh &>/dev/null); then
  install_pkg_${OS} zsh &>/dev/null || {
    _error "zsh is not installed. Setup scripts failed to install it."
    exit 1
  }
fi

if [ "awk -F: \"/$(whoami)/ {print \$NF}\" /etc/passwd" != "$(command -v zsh)" ]; then
  _info "Changing default shell to ${CYAN}zsh"
  sudo chsh -s $(command -v zsh) "$(whoami)"
fi

[ -d "${HOME}/.zsh" ] || mkdir -p "${HOME}/.zsh"

for plugin in "${ZSH_PLUGINS[@]}"; do
  plugin_name="$(basename "${plugin}")"
  if [ ! -d "${HOME}/.zsh/${plugin_name}" ]; then
    _info "Cloning zsh plugin: ${plugin_name}"
    (cd "${HOME}/.zsh/" && git clone https://github.com/${plugin}.git 2>/dev/null)
  else
    _info "Updating zsh plugin ${YELLOW}${plugin_name}"
    (cd "${HOME}/.zsh/${plugin_name}/" && git pull --rebase &>/dev/null)
  fi
  unset plugin plugin_name
done

# sanitize permissions
(zsh -i -c 'compaudit | sed 1d | xargs chmod 750 &>/dev/null') || true
