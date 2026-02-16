#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

ZSH_PLUGINS=(
	'marlonrichert/zsh-autocomplete'
	'zsh-users/zsh-autosuggestions'
	'zsh-users/zsh-syntax-highlighting'
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

[ -d "${HOME}/.zsh" ] || mkdir -p "${HOME}/.zsh"

for plugin in "${ZSH_PLUGINS[@]}"; do
	plugin_name="$(basename "${plugin}")"
	if [ ! -d "${HOME}/.zsh/${plugin_name}" ]; then
		_info "Cloning zsh plugin: ${plugin_name}"
		(
			cd "${HOME}/.zsh/" && git clone https://github.com/${plugin}.git 2>/dev/null
		)
	else
		_info "Updating zsh plugin ${YELLOW}${plugin_name}"
		(cd "${HOME}/.zsh/${plugin_name}/" && git pull --rebase &>/dev/null && echo "Done")
	fi
	unset plugin plugin_name
done

# sanitize permissions
(zsh -i -c 'compaudit | sed 1d | xargs chmod 750 &>/dev/null')

# Install iTerm2 Shell Integration
[ -n "${ITERM_SESSION_ID}" ] &&
	curl ${GITHUB_AUTH} --create-dirs -o "${HOME}/.config/iterm2/shell_integration.zsh" -L https://iterm2.com/shell_integration/zsh
