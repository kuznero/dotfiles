# af-magic.zsh-theme (customized)
#
# Based on: https://github.com/ohmyzsh/ohmyzsh/blob/master/themes/af-magic.zsh-theme
# Modifications: removed dashed separator, use λ instead of », shortened path
#
# Author: Andy Fleming
# URL: http://andyfleming.com/

# Shorten path: first char for intermediate dirs, full name for last 3
# e.g., ~/Data/Projects/kuznero/dotfiles/branches/main → ~/D/P/k/dotfiles/branches/main
_afmagic_short_pwd() {
  local pwd_str="${PWD/#$HOME/~}"
  local -a parts
  parts=("${(@s:/:)pwd_str}")

  local count=${#parts[@]}
  local keep_full=3

  if [[ $count -le $((keep_full + 1)) ]]; then
    # Path is short enough, show as-is
    echo "$pwd_str"
  else
    local result=""
    local i
    for ((i = 1; i <= count; i++)); do
      if [[ $i -eq 1 && "${parts[$i]}" == "~" ]]; then
        result="~"
      elif [[ $i -gt $((count - keep_full)) ]]; then
        # Last N dirs: keep full name
        result+="/${parts[$i]}"
      else
        # Intermediate dirs: first char only
        result+="/${parts[$i]:0:1}"
      fi
    done
    echo "$result"
  fi
}

# primary prompt: directory and vcs info (no dashed separator)
PS1='${FG[032]}$(_afmagic_short_pwd)$(git_prompt_info)$(hg_prompt_info) ${FG[105]}%(!.#.λ)%{$reset_color%} '
PS2="%{$fg[red]%}\ %{$reset_color%}"

# right prompt: return code, virtualenv and context (user@host)
RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi
RPS1+=" ${FG[237]}%n@%m%{$reset_color%}"

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
