# get zsh load time - START
# prefer gnu-date
[[ "$OSTYPE" =~ "darwin" ]] && ( type gdate &>/dev/null ) && alias date='gdate'
_zsh_start="$(date +%s%3N)"

# zsh
FPATH="${FPATH}:$(brew --prefix)/share/zsh/site-functions:${HOME}/.zsh/zsh-completions/src"
ZSH_PLUGINS=(zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)
for plugin in ${ZSH_PLUGINS[@]} ; do
    [ -f "${HOME}/.zsh/${plugin}/${plugin}.zsh" ] &&
    source ${HOME}/.zsh/${plugin}/${plugin}.zsh
done
# compinit (if having issues, delete ~/.zcompdump and re-run to rebuild)
autoload -Uz compinit ; compinit
# load ~/.zshrc_custom
[ -r "${HOME}/.zshrc_custom" ] && source "${HOME}/.zshrc_custom"

# starship
export STARSHIP_CONFIG=~/.config/starship/starship.toml
eval "$(starship init zsh)"

if [ -z "${TMUX}" ] ; then
	# print random fortune cookie
	cookie
	# list tmux sessions
  tmux ls 2>/dev/null | while read session ; do _banner "tmux session:${NONE} ${session}" ; done ; echo
fi

# get zsh load time - END
_zsh_end="$(date +%s%3N)"
printf " %.3f s\\n" "$(( ${_zsh_end} - ${_zsh_start} ))e-3"
unset _zsh_start _zsh_end
