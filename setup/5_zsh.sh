#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

# https://github.com/marlonrichert/zsh-autocomplete.git
ZSH_PLUGINS=(
	'marlonrichert/zsh-autocomplete'
	'zsh-users/zsh-autosuggestions'
	'zsh-users/zsh-completions'
	'zsh-users/zsh-history-substring-search'
	'zsh-users/zsh-syntax-highlighting'
	'MichaelAquilina/zsh-you-should-use'
)

source "$(dirname "${0}")/.functions" || exit 1

if ! command -v zsh >/dev/null 2>&1; then
	install_pkg_${OS} zsh &>/dev/null || {
		_error "zsh is not installed. Setup scripts failed to install it."
		exit 1
	}
fi

_info "Changing default shell to ${CYAN}zsh"
sudo chsh -s $(command -v zsh) "$(whoami)" && _success "Done"
# [ -f "${HOME}/.zshrc" ] && mv -f "${HOME}/.zshrc" "${HOME}/.zshrc.bak"

[ -d "${HOME}/.zsh" ] || mkdir -p "${HOME}/.zsh"

for plugin in "${ZSH_PLUGINS[@]}"; do
	plugin_name="$(basename "${plugin}")"
	if [ ! -d "${HOME}/.zsh/${plugin_name}" ]; then
		# git clone https://github.com/zsh-users/${plugin} ${HOME}/.zsh/${plugin} 2>/dev/null ||
		_info "Cloning zsh plugin: ${plugin_name} (https://github.com/${plugin}.git)"
		(
			cd "${HOME}/.zsh/" && git clone https://github.com/${plugin}.git 2>/dev/null
			# echo "cd ${HOME}/.zsh/ && git clone https://github.com/${plugin}.git"
		)
	else
		_info "Updating zsh plugin ${YELLOW}${plugin_name}"
		(cd "${HOME}/.zsh/${plugin_name}/" && git pull --rebase)
	fi
	unset plugin plugin_name
done

# Install iTerm2 Shell Integration
[ -n "${ITERM_SESSION_ID}" ] &&
	curl ${GITHUB_AUTH} --create-dirs -o "${HOME}/.config/iterm2/shell_integration.zsh" -L https://iterm2.com/shell_integration/zsh
