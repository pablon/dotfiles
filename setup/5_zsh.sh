#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

set -euo pipefail

source "$(dirname "${0}")/.functions" || exit 1

ZSH_PLUGINS=(
  'marlonrichert/zsh-autocomplete:26.08.04'
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

# Plugins with version pinning use format: "owner/repo:tag"
for plugin in "${ZSH_PLUGINS[@]}"; do
  plugin_repo="${plugin%%:*}"
  plugin_tag="${plugin#*:}"
  if [ "${plugin_tag}" = "${plugin}" ]; then
    plugin_tag="" # no pin
  fi
  plugin_name="$(basename "${plugin_repo}")"
  if [ ! -d "${HOME}/.zsh/${plugin_name}" ]; then
    _info "Cloning zsh plugin: ${plugin_name}"
    (cd "${HOME}/.zsh/" && git clone "https://github.com/${plugin_repo}.git" 2>/dev/null)
    if [ -n "${plugin_tag}" ]; then
      (cd "${HOME}/.zsh/${plugin_name}/" && git checkout "${plugin_tag}" -- &>/dev/null)
      _info "  Pinned ${YELLOW}${plugin_name}${NC} to tag ${YELLOW}${plugin_tag}${NC}"
    fi
  else
    _info "Updating zsh plugin ${YELLOW}${plugin_name}"
    if [ -n "${plugin_tag}" ]; then
      git -C "${HOME}/.zsh/${plugin_name}/" fetch --tags origin &>/dev/null &&
        git -C "${HOME}/.zsh/${plugin_name}/" checkout "${plugin_tag}" -- &>/dev/null
    else
      git -C "${HOME}/.zsh/${plugin_name}/" pull &>/dev/null
    fi
  fi
  unset plugin plugin_repo plugin_tag plugin_name
done

# sanitize permissions (ZSH_DISABLE_COMPFIX prevents zsh-newuser-install on first run)
ZSH_DISABLE_COMPFIX=true zsh -i -c 'compaudit | sed 1d | xargs chmod 750 &>/dev/null' || true
