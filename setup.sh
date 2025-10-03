#!/usr/bin/env bash
##########################################################
# Description: setup dotfiles @ new machine
# Author: https://github.com/pablon
##########################################################

source "$(dirname "${0}")/setup/.functions" || exit 1

if [ -d ${HOME}/dotfiles ]; then
	# setup scripts
	(
		cd ${HOME}/dotfiles/setup/ || exit 1
		for f in *.sh; do
			divider
			_info "Running ${GREEN}$f"
			bash "$f" || exit 1
		done
	)

	# backup
	STOW_VER="$(stow --version | awk '{print $NF}')"
	STOW_VER="${STOW_VER%.*}"
	(
		cd "${HOME}/dotfiles/"
		divider
		_info "Backing up existing files"
		if [ 1 -eq "$(echo "${STOW_VER} > 2.3" | bc)" ]; then
			(cd ${HOME}/dotfiles/ && stow -nv . 2>&1) |
				awk '/neither a link nor a directory|existing target is not owned by stow/ {print $8}' | while read i; do
				mv -vf ${HOME}/${i}{,.$(date +%Y%m%d-%H%M%S)}
			done
		else
			(cd ${HOME}/dotfiles/ && stow -nv . 2>&1) |
				awk '/neither a link nor a directory|existing target is not owned by stow/ {print $NF}' | while read i; do
				mv -vf ${HOME}/${i}{,.$(date +%Y%m%d-%H%M%S)}
			done
		fi
	)
	# link
	divider
	_info "Linking files"
	(cd ${HOME}/dotfiles/ && stow -v .)

	_success "Now reload your shell:\n\t${GREEN}source ~/.zshrc\n"
fi
