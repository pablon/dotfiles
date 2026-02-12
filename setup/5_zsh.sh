#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

ZSH_PLUGINS=(zsh-completions zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)

source "$(dirname "${0}")/.functions" || exit 1

_info "Changing default shell to ${CYAN}zsh"
sudo chsh -s $(command -v zsh) "$(whoami)" && _success "Done"
# [ -f "${HOME}/.zshrc" ] && mv -f "${HOME}/.zshrc" "${HOME}/.zshrc.bak"

[ -d "${HOME}/.zsh" ] || mkdir -p "${HOME}/.zsh"

for plugin in "${ZSH_PLUGINS[@]}"; do
	if [ ! -f "${HOME}/.zsh/${plugin}/${plugin}.zsh" ]; then
		git clone https://github.com/zsh-users/${plugin} ${HOME}/.zsh/${plugin} 2>/dev/null ||
			exit 1
	else
		_info "Updating zsh plugin ${YELLOW}${plugin}"
		(cd "${HOME}/.zsh/${plugin}/" && git pull --rebase)
	fi
done

# Install iTerm2 Shell Integration
[ -n "${ITERM_SESSION_ID}" ] &&
	curl ${GITHUB_AUTH} --create-dirs -o "${HOME}/.config/iterm2/shell_integration.zsh" -L https://iterm2.com/shell_integration/zsh
