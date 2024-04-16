#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

# check for oh-my-zsh, or install it
if [ ! -d "${HOME}/.oh-my-zsh/" ] ; then
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

# install plugins
# https://linuxhint.com/use-zsh-auto-suggestions/
# https://github.com/zsh-users/zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-history-substring-search
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search ; do
  git clone https://github.com/zsh-users/${plugin} \
    ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/${plugin}
done

# make sure ~/.zshrc calls ~/.zshrc_custom
if ( ! grep '${HOME}/.zshrc_custom' "${HOME}/.zshrc" &>/dev/null ) ; then
  echo -e "\n[ -r \"\${HOME}/.zshrc_custom\" ] && source \"\${HOME}/.zshrc_custom\"" >> "${HOME}/.zshrc"
fi

# reload
echo -e "🔄 reloading shell configuration"
reset ; source "${HOME}/.zshrc"

echo "✅ Done"
