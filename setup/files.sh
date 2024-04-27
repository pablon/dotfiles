#!/usr/bin/env bash
##########################################################
# Description: Installs files in your $HOME
# Author: https://github.com/pablon
##########################################################

FILE_LIST=".actrc .aliases .functions .gitconfig .tmux.conf .vimrc .zshrc_custom"
FILES_DIR="$(dirname ${0})/../"

for file in ${FILE_LIST} ; do
  install -B ".$(date +%Y%m%d.%H%M%S)" -b  -C -v -m 600 -S "${FILES_DIR}/${file}" "${HOME}"
done

mkdir -p "${HOME}/.vim/autoload/plugged"
curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

echo "✅ Done"
