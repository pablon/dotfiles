# shellcheck disable=SC2148
# get zsh load time - START
# prefer gnu-date
[[ "$(uname)" == "Darwin" ]] && ( type gdate &>/dev/null ) && alias date='gdate'
_zsh_start="$(date +%s%3N)"

# load ~/.zshrc_custom
[ -r "${HOME}/.zshrc_custom" ] && source "${HOME}/.zshrc_custom"

# zsh plugins
ZSH_PLUGINS=(zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
for plugin in "${ZSH_PLUGINS[@]}" ; do
    [ -f "${HOME}/.zsh/${plugin}/${plugin}.zsh" ] &&
    source ${HOME}/.zsh/${plugin}/${plugin}.zsh
done

# atuin
eval "$(atuin init zsh --disable-up-arrow)"

# starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"
eval "$(starship init zsh)"

cookie
if [ -z "${TMUX}" ] ; then
  tmux ls 2>/dev/null | while read session ; do _info "tmux session:${NONE} ${session}" ; done ; echo
fi

# get zsh load time - END
_zsh_end="$(date +%s%3N)"
printf " %.3f s\\n" "$(( ${_zsh_end} - ${_zsh_start} ))e-3"
unset _zsh_start _zsh_end
