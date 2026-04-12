# shellcheck disable=SC2149
# start zsh profiling
zmodload zsh/zprof

# get zsh load time - START
# prefer gnu-date
[[ "$(uname)" == "Darwin" ]] && (type gdate &>/dev/null) && alias date='gdate'
_zsh_start="$(date +%s%3N)"

# zsh-autocomplete: disable async BEFORE plugin load (checked at init time, not precmd)
zstyle ':autocomplete:async' enabled no
# zsh-autosuggestions: disable async to prevent dual fd-handler deadlock with autocomplete
typeset -g ZSH_AUTOSUGGEST_MANUAL_REBIND=1

# load zsh plugins
for plugin in $(\ls -1 ${HOME}/.zsh/ | sort | xargs); do
  plugin_dir="${HOME}/.zsh/${plugin}"
  plugin_file="$(find "${plugin_dir}" -maxdepth 1 -type f -name '*.plugin.zsh' 2>/dev/null | head -1)"
  [[ -n "${plugin_file}" ]] && source "${plugin_file}"
  unset plugin plugin_dir plugin_file
done

# load ~/.zshrc_base (setup)
[ -r "${HOME}/.zshrc_base" ] && source "${HOME}/.zshrc_base"
# load ~/.zshrc_custom (user) if exists
[ -r "${HOME}/.zshrc_custom" ] && source "${HOME}/.zshrc_custom"

# fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# load atuin
[ -x "${HOME}/.atuin/bin/env" ] && source "${HOME}/.atuin/bin/env" &>/dev/null
eval "$(atuin init --disable-up-arrow zsh)"

# load starship
export STARSHIP_CONFIG="${XDG_CONFIG_HOME}/starship/starship.toml"
eval "$(starship init zsh)"

# load direnv hook
(type direnv &>/dev/null) && eval "$(direnv hook zsh)"

# print a random cookie （╯°□°）╯ ┻━┻
cookie

# list tmux sessions if not in tmux
if [ -z "${TMUX}" ]; then
  tmux ls 2>/dev/null | while read session; do _info "tmux session:${NC} ${session}"; done
  echo
fi

# get zsh load time - END
_zsh_end="$(date +%s%3N)"
printf " %.3f s\\n" "$((${_zsh_end} - ${_zsh_start}))e-3"
unset _zsh_start _zsh_end

# save zsh profiling and unload profiler to avoid overhead during session
zprof 2>&1 >~/.zsh.profiling
zmodload -u zsh/zprof
