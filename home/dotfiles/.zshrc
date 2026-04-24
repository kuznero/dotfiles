EDITOR=vim

# 1Password SSH agent
if [ -S "$HOME/.1password/agent.sock" ]; then
  export SSH_AUTH_SOCK="$HOME/.1password/agent.sock"
fi

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

command -v nix >/dev/null 2>&1 && {
  alias dev='nix develop'
}

command -v k9s >/dev/null 2>&1 && {
  alias kk='k9s --request-timeout=10s --headless'
}

command -v kubectl >/dev/null 2>&1 && {
  alias k='kubectl'
  # shellcheck disable=SC1090
  source <(kubectl completion zsh)
  # complete -F __start_kubectl k
}

command -v switcher >/dev/null 2>&1 && {
  source <(switcher init zsh)
  alias s=switch
  source <(switch completion zsh)
}

command -v helm >/dev/null 2>&1 && {
  alias h='helm'
  # shellcheck disable=SC1090
  source <(helm completion zsh)
  # complete -F __start_helm h
}

command -v flux >/dev/null 2>&1 && {
  alias f='flux'
  # shellcheck disable=SC1090
  source <(flux completion zsh)
  # complete -F __start_flux f
}

command -v eza >/dev/null 2>&1 && {
  alias ls='eza'
}

command -v bat >/dev/null 2>&1 && {
  alias cat='bat'
}

command -v fzf >/dev/null 2>&1 && {
  source <(fzf --zsh)
}

command -v talosctl >/dev/null 2>&1 && {
  source <(talosctl completion zsh)
}

command -v task >/dev/null 2>&1 && {
  alias t='task'
  source <(task --completion zsh)
}

command -v ccusage >/dev/null 2>&1 && {
  alias cc-today='ccusage daily --since $(date +%Y%m%d) --until $(date +%Y%m%d)'
  alias cc-live='ccusage blocks --live'
}

export RPROMPT='$([[ "$KUBE_PS1_CONTEXT" == "N/A" ]] || echo "%F{red}$KUBE_PS1_CONTEXT%f "):: %F{green}$NIX_FLAKE_NAME%f'
