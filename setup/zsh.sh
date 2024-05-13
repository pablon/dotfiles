#!/usr/bin/env bash
##########################################################
# Description: pimp my zsh
# Author: https://github.com/pablon
##########################################################

# check for oh-my-zsh, or install it
if [ ! -d "${HOME}/.oh-my-zsh" ] ; then
  (
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  )
fi

export ZSH="${HOME}/.oh-my-zsh"

# Install iTerm2 Shell Integration
curl --create-dirs -o "${HOME}/.config/iterm2/shell_integration.zsh" -L https://iterm2.com/shell_integration/zsh

# install plugins
# https://linuxhint.com/use-zsh-auto-suggestions/
# https://github.com/zsh-users/zsh-syntax-highlighting
# https://github.com/zsh-users/zsh-history-substring-search
for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search ; do
  # shellcheck disable=SC2086
  git clone https://github.com/zsh-users/${plugin} ${ZSH_CUSTOM:-${ZSH}/custom}/plugins/${plugin}
done

# tweaks
MY_ZSH_THEME='sorin'
PLUGINS="aws brew docker docker-compose git kube-ps1 kubectl ripgrep terraform minikube zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search"

# shellcheck disable=SC2086
sed -i -e "s|$(awk -F'"' '/^ZSH_THEME/ {print $2}' ${HOME}/.zshrc)|${MY_ZSH_THEME}|" \
  -e "/DISABLE_UPDATE_PROMPT/ s|^#\ ||" \
  -e "/zstyle ':omz:update' mode auto/ s|^#\ ||" \
  -e "/DISABLE_MAGIC_FUNCTIONS/ s|^#\ ||" \
  -e "/HIST_STAMPS/ s|^.*$|HIST_STAMPS=\"yyyy-mm-dd\"|" \
  -e "/^plugins/ s|^.*$|plugins=(${PLUGINS})|" "${HOME}/.zshrc"

# make sure ~/.zshrc calls ~/.zshrc_custom
# shellcheck disable=SC2016
if ( ! grep '${HOME}/.zshrc_custom' "${HOME}/.zshrc" &>/dev/null ) ; then
  echo -e "\n# load ~/.zshrc_custom\n[ -r \"\${HOME}/.zshrc_custom\" ] && source \"\${HOME}/.zshrc_custom\"\n" >> "${HOME}/.zshrc"
fi

# powerline fonts
git clone https://github.com/powerline/fonts.git --depth=1 && ( cd ./fonts/ && ./install.sh ) && rm -rf ./fonts

# tmux stuff
if ( command -v python3 &>/dev/null ) && ( command -v tmux &>/dev/null ) ; then
  (
    # shellcheck disable=SC1091
    python3 -m venv "${HOME}/.powerline" && \
    source "${HOME}/.powerline/bin/activate" && \
    pip3 install powerline-status psutil
  )
fi

# vim stuff
mkdir -p "${HOME}/.vim/autoload/plugged"
curl -fLo "${HOME}/.vim/autoload/plug.vim" --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# install plugins
vim -E -s -u "${HOME}/.vimrc" +PlugInstall -qall

echo "✅ Done"
echo "🔄 Close and reopen your terminal to reload all new configurations"
exit
