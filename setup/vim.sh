#!/usr/bin/env bash
##########################################################
# Description: install vim + plugins
# Author: https://github.com/pablon
##########################################################

(type vim &>/dev/null) || brew install vim

source "$(git rev-parse --show-toplevel)/setup/.functions" &>/dev/null

mkdir -p "${HOME}/.vim/autoload/plugged"
curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# install plugins
vim -E -s -u "${HOME}/.vimrc" +PlugInstall +qall

_info "✅ Done ${0}"
