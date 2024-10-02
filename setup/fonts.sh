#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

NERD_FONTS=(Hack JetBrainsMono)

PROJECT='ryanoasis/nerd-fonts'
LATEST="$(curl -s "https://api.github.com/repos/${PROJECT}/releases/latest" | jq -r ".tag_name")"

source ./.functions &>/dev/null

if [[ "${OSTYPE}" =~ "darwin" ]]; then
	TARGET_DIR=~/Library/Fonts
elif [[ "${OSTYPE}" =~ "linux" ]]; then
	TARGET_DIR=~/.local/share/fonts
fi
[ -d ${TARGET_DIR} ] || mkdir -p ${TARGET_DIR}
cd ${TARGET_DIR}/ || exit 1

for font in "${NERD_FONTS[@]}"; do
	_print "Downloading font ${font}"
	curl -fsSL https://github.com/${PROJECT}/releases/download/${LATEST}/${font}.zip -o ${font}.zip &&
		unzip -oq ${font}.zip &&
		rm -f ${font}.zip
done

_print "Runnning fc-cache"
fc-cache -f

_print "✅ Done ${0}"
