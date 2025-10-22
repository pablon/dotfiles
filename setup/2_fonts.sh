#!/usr/bin/env bash
##########################################################
# Description: pimp my fonts
# Author: https://github.com/pablon
##########################################################

source "$(dirname "${0}")/.functions" || exit 1

NERD_FONTS=('Hack' 'JetBrainsMono' 'FiraCode')

PROJECT='ryanoasis/nerd-fonts'
LATEST="$(curl -s "https://api.github.com/repos/${PROJECT}/releases/latest" | jq -r ".tag_name")"

case "$(uname)" in
'Darwin')
  TARGET_DIR=~/Library/Fonts
  ;;
'Linux')
  TARGET_DIR=~/.local/share/fonts
  ;;
esac

[ -d "${TARGET_DIR}" ] || mkdir -p "${TARGET_DIR}"

for font in "${NERD_FONTS[@]}"; do
  (
    cd "${TARGET_DIR}/" || exit 1
    _info "Downloading ttf font ${CYAN}${font}"
    \curl -fsSL "https://github.com/${PROJECT}/releases/download/${LATEST}/${font}.zip" -o "${font}.zip" &&
      unzip -oq "${font}.zip" &&
      rm -f "${font}.zip"
  )
done

_info "Running fc-cache"
fc-cache -f

_success "Done ${0}"
