#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

ZSH_PLUGINS=(zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)

source ./.functions &>/dev/null

for plugin in "${ZSH_PLUGINS[@]}"; do
	[ -f "${HOME}/.zsh/${plugin}/${plugin}.zsh" ] ||
		git clone https://github.com/zsh-users/${plugin} ${HOME}/.zsh/${plugin} 2>/dev/null
done

# Install iTerm2 Shell Integration
[ -n "${ITERM_SESSION_ID}" ] &&
	curl --create-dirs -o "${HOME}/.config/iterm2/shell_integration.zsh" -L https://iterm2.com/shell_integration/zsh

_print "✅ Done ${0}"
