#!/usr/bin/env bash
##########################################################
# Description: install tmux plugin manager
# Author: https://github.com/pablon
##########################################################

source ./.functions &>/dev/null

if [ ! -d ~/.tmux/plugins/tpm ]; then
	# we need a ~/.tmux.conf to install tpm & plugins
	if [[ ! -e ~/.tmux.conf ]]; then
		TMUX_CONF_TMP=1
		ln -vs ~/dotfiles/.tmux.conf ~/.tmux.conf
	fi
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm &&
		~/.tmux/plugins/tpm/scripts/install_plugins.sh
	if [[ "${TMUX_CONF_TMP}" ]]; then
		unlink ~/.tmux.conf
	fi
fi

_print "✅ Done ${0}"
