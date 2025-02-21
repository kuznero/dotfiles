EDITOR=nvim

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ "$TERM_PROGRAM" = vscode ]]; then
  export EDITOR=code;
  alias vim=code;
  alias v=code;
fi

command -v nix >/dev/null 2>&1 && {
  alias dev='nix develop'
}

command -v k9s >/dev/null 2>&1 && {
  alias kk='k9s --request-timeout=10s --headless --command namespaces'
}

command -v kubectl >/dev/null 2>&1 && {
  alias k='kubectl'
  # shellcheck disable=SC1090
  source <(kubectl completion zsh)
  # complete -F __start_kubectl k
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

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function tm() {
  if [ -n "$TMUX" ]; then
    echo "Script is already running inside a tmux session"
  else
    SESSION=$1

    if [ -z "$SESSION" ]; then
      SESSION=$(basename "$(pwd)")
      SESSION=$(echo "$SESSION" | tr '.' '-' | tr '[:upper:]' '[:lower:]')
    fi

    if tmux has-session -t "$SESSION" 2>/dev/null; then
      echo "$SESSION session already exists. Attaching..."
      tmux attach-session -t "$SESSION"
      return 0
    fi

    COMMAND="$SHELL"
    tmux new-session -d -s $SESSION "$COMMAND"

    COUNTER=1
    WINDOWS=("ops")
    for name in "${WINDOWS[@]}"; do
      COUNTER=$((COUNTER+1))
      tmux new-window -t "$SESSION:$COUNTER" -n "$name" "$COMMAND"
    done

    tmux split-window -v -t "$SESSION:$COUNTER"
    tmux select-pane -t "$SESSION:$COUNTER.1"

    tmux select-window -t "$SESSION:1"
    tmux rename-window -t "$SESSION:1" "$SESSION"

    tmux attach-session -t "$SESSION"
  fi
}

if [ -n "$NIX_FLAKE_NAME" ]; then
  export RPROMPT="%F{green}($NIX_FLAKE_NAME)%f";
fi
