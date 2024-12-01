#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

NERD_FONTS=(Hack JetBrainsMono)

PROJECT='ryanoasis/nerd-fonts'
LATEST="$(curl -s "https://api.github.com/repos/${PROJECT}/releases/latest" | jq -r ".tag_name")"

source "$(git rev-parse --show-toplevel)/setup/.functions" &>/dev/null

if [[ "${OSTYPE}" =~ "darwin" ]]; then
  TARGET_DIR=~/Library/Fonts
elif [[ "${OSTYPE}" =~ "linux" ]]; then
  TARGET_DIR=~/.local/share/fonts
fi
[ -d ${TARGET_DIR} ] || mkdir -p ${TARGET_DIR}
cd ${TARGET_DIR}/ || exit 1

for font in "${NERD_FONTS[@]}"; do
  _info "Downloading font ${font}"
  curl -fsSL https://github.com/${PROJECT}/releases/download/${LATEST}/${font}.zip -o ${font}.zip &&
    unzip -oq ${font}.zip &&
    rm -f ${font}.zip
done

_info "Runnning fc-cache"
fc-cache -f

_info "✅ Done ${0}"
