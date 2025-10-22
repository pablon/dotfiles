#!/usr/bin/env bash
##########################################################
# Description: install vim + plugins
# Author: https://github.com/pablon
##########################################################

source "$(dirname "${0}")/.functions" || exit 1

(type vim &>/dev/null) || install_pkg_${OS} vim

REPO_ROOT="$(git rev-parse --show-toplevel)"
mkdir -p "${HOME}/.vim/autoload/plugged"
curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ||
	exit 1

# install plugins
vim -E -s -u "${REPO_ROOT}/.vimrc" +PlugInstall +qall

_success "Done ${0}"
