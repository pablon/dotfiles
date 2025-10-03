#!/usr/bin/env bash
##########################################################
# Description: install vim + plugins
# Author: https://github.com/pablon
##########################################################

(type vim &>/dev/null) || install_pkg_${OS} vim

source "$(dirname "${0}")/.functions" || exit 1

mkdir -p "${HOME}/.vim/autoload/plugged"
curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install plugins
vim -E -s -u "${HOME}/.vimrc" +PlugInstall +qall

_success "Done ${0}"
