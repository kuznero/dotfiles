# kuznero.zsh-theme
#
# Repo-owned prompt theme based on Oh My Zsh's af-magic theme.

# Shorten path: first char for intermediate dirs, full name for last 3.
# e.g. ~/Data/Projects/kuznero/dotfiles/branches/main -> ~/D/P/k/dotfiles/branches/main
_kuznero_short_pwd() {
  local pwd_str="${PWD/#$HOME/~}"
  local -a parts
  parts=("${(@s:/:)pwd_str}")

  local count=${#parts[@]}
  local keep_full=3

  if [[ $count -le $((keep_full + 1)) ]]; then
    print -r -- "$pwd_str"
    return
  fi

  local result=""
  local i
  for ((i = 1; i <= count; i++)); do
    if [[ $i -eq 1 && "${parts[$i]}" == "~" ]]; then
      result="~"
    elif [[ $i -gt $((count - keep_full)) ]]; then
      result+="/${parts[$i]}"
    else
      result+="/${parts[$i]:0:1}"
    fi
  done

  print -r -- "$result"
}

_kuznero_prompt_context() {
  local context=""

  if [[ -n "$KUBE_PS1_CONTEXT" && "$KUBE_PS1_CONTEXT" != "N/A" ]]; then
    context+="%F{red}${KUBE_PS1_CONTEXT}%f "
  fi

  context+=":: "

  if [[ -n "$NIX_FLAKE_NAME" ]]; then
    context+="%F{green}${NIX_FLAKE_NAME}%f "
  fi

  context+="@ %F{237}%m%f"

  print -r -- "$context"
}

_kuznero_visible_length() {
  emulate -L zsh -o extended_glob

  local value="${(%)1}"
  value="${value//$'\e'\[[0-9;]##m/}"

  print -r -- ${#value}
}

_kuznero_git_prompt_info() {
  command git rev-parse --is-inside-work-tree >/dev/null 2>&1 || return

  local ref
  ref="$(command git symbolic-ref --quiet --short HEAD 2>/dev/null || command git rev-parse --short HEAD 2>/dev/null)" || return

  local dirty="$ZSH_THEME_GIT_PROMPT_CLEAN"
  if [[ -n "$(command git status --porcelain --ignore-submodules=dirty 2>/dev/null)" ]]; then
    dirty="$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi

  print -nr -- "${ZSH_THEME_GIT_PROMPT_PREFIX}${ref}${dirty}${ZSH_THEME_GIT_PROMPT_SUFFIX}"
}

_kuznero_prompt_header() {
  local left="${FG[032]}$(_kuznero_short_pwd)$(_kuznero_git_prompt_info)$(hg_prompt_info)%{$reset_color%}"
  local right="$(_kuznero_prompt_context)"
  local left_len="$(_kuznero_visible_length "$left")"
  local right_len="$(_kuznero_visible_length "$right")"
  local columns=${COLUMNS:-80}
  local gap=$((columns - left_len - right_len))

  (( gap < 1 )) && gap=1

  print -nr -- "$left"
  printf '%*s' "$gap" ''
  print -nr -- "$right"
}

_kuznero_prompt_symbol=">"
case "${LC_ALL:-${LC_CTYPE:-$LANG}}" in
  *UTF-8*|*utf-8*|*UTF8*|*utf8*)
    _kuznero_prompt_symbol="λ"
    ;;
esac

# First line carries location and context; second line is reserved for typing.
PS1='$(_kuznero_prompt_header)
%(?.${FG[105]}.%{$fg[red]%}[%?] )%(!.#.${_kuznero_prompt_symbol})%{$reset_color%} '
PS2="%{$fg[red]%}\ %{$reset_color%}"
RPS1=""
RPROMPT=""

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# hg settings
ZSH_THEME_HG_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[075]}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"
