EDITOR=vim

if [[ -f "/opt/homebrew/bin/brew" ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [[ "$TERM_PROGRAM" = vscode ]]; then
  export EDITOR=code;
  alias vim=code;
  alias v=code;
fi

if [ -d "/Applications/1Password.app/Contents/MacOS" ]; then
  export PATH=$PATH:/Applications/1Password.app/Contents/MacOS
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

function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

function tm() {
  local USE_NIX=true
  local SESSION=""

  # Parse arguments
  for arg in "$@"; do
    if [ "$arg" = "--nonix" ]; then
      USE_NIX=false
    else
      SESSION="$arg"
    fi
  done

  if [ -z "$SESSION" ]; then
    # Try to derive session name from git repository
    if git rev-parse --git-dir >/dev/null 2>&1; then
      local repo_root
      repo_root=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)

      if [ -n "$repo_root" ]; then
        # Get repository name
        # For normal repos, repo_root ends with .git, for bare repos it's the repo dir itself
        local repo_name
        if [ "$(basename "$repo_root")" = ".git" ]; then
          # Normal repo: use parent directory name
          repo_name=$(basename "$(dirname "$repo_root")")
        else
          # Bare repo: use repo_root basename
          repo_name=$(basename "$repo_root")
        fi

        # Check if we're in a worktree
        local worktree_path
        worktree_path=$(git rev-parse --show-toplevel 2>/dev/null)

        if [ -n "$worktree_path" ]; then
          # For normal repos, check if worktree_path is the repo itself
          if [ "$(basename "$repo_root")" = ".git" ] && [ "$worktree_path" = "$(dirname "$repo_root")" ]; then
            # Normal clone (not a worktree): just use repo name
            SESSION="$repo_name"
          elif [ "$worktree_path" != "$repo_root" ]; then
            # We're in a worktree, get the worktree/branch name
            local worktree_name
            worktree_name=$(basename "$worktree_path")
            SESSION="${repo_name}/${worktree_name}"
          else
            # In bare repo, indicate with /bare
            SESSION="${repo_name}/bare"
          fi
        else
          # No worktree (likely in bare repo), indicate with /bare
          SESSION="${repo_name}/bare"
        fi
      else
        # Fallback to directory-based name
        SESSION="$(basename "$(dirname "$(pwd)")")/$(basename "$(pwd)")"
      fi
    else
      # Not a git repo, use directory-based name
      SESSION="$(basename "$(dirname "$(pwd)")")/$(basename "$(pwd)")"
    fi

    SESSION=$(echo "$SESSION" | tr '.' '-' | tr '[:upper:]' '[:lower:]')
  fi

  # Check if we're already in tmux
  if [ -n "$TMUX" ]; then
    CURRENT_SESSION=$(tmux display-message -p '#S')

    # If we're already in the target session, do nothing
    if [ "$CURRENT_SESSION" = "$SESSION" ]; then
      echo "Already in session: $SESSION"
      return 0
    fi

    # We're in tmux but targeting a different session
    if tmux has-session -t "$SESSION" 2>/dev/null; then
      echo "Switching to existing session: $SESSION"
      tmux switch-client -t "$SESSION"
      return 0
    fi

    # Target session doesn't exist, create it and switch
    echo "Creating and switching to new session: $SESSION"
    COMMAND="$SHELL"
    tmux new-session -d -s $SESSION "$COMMAND"

    COUNTER=1
    WINDOWS=("src" "ops")
    for name in "${WINDOWS[@]}"; do
      COUNTER=$((COUNTER+1))
      tmux new-window -t "$SESSION:$COUNTER" -n "$name" "$COMMAND"
    done

    tmux select-window -t "$SESSION:1"
    tmux rename-window -t "$SESSION:1" "claude"

    # Send nix develop to all windows if flake.nix exists and --nonix not set
    if [ "$USE_NIX" = true ] && [ -f "flake.nix" ]; then
      tmux send-keys -t "$SESSION:1" "nix develop" C-m
      tmux send-keys -t "$SESSION:2" "nix develop" C-m
      tmux send-keys -t "$SESSION:3" "nix develop" C-m
    fi

    tmux switch-client -t "$SESSION"
    return 0
  fi

  # Not in tmux, use attach/create logic
  if tmux has-session -t "$SESSION" 2>/dev/null; then
    echo "$SESSION session already exists. Attaching..."
    tmux attach-session -t "$SESSION"
    return 0
  fi

  COMMAND="$SHELL"
  tmux new-session -d -s $SESSION "$COMMAND"

  COUNTER=1
  WINDOWS=("src" "ops")
  for name in "${WINDOWS[@]}"; do
    COUNTER=$((COUNTER+1))
    tmux new-window -t "$SESSION:$COUNTER" -n "$name" "$COMMAND"
  done

  tmux select-window -t "$SESSION:1"
  tmux rename-window -t "$SESSION:1" "claude"

  # Send nix develop to all windows if flake.nix exists and --nonix not set
  if [ "$USE_NIX" = true ] && [ -f "flake.nix" ]; then
    tmux send-keys -t "$SESSION:1" "nix develop" C-m
    tmux send-keys -t "$SESSION:2" "nix develop" C-m
    tmux send-keys -t "$SESSION:3" "nix develop" C-m
  fi

  tmux attach-session -t "$SESSION"
}

function ts() {
  local session
  session=$(tmux list-sessions -F "#{session_name}: #{session_windows} windows (created #{session_created})" 2>/dev/null | \
    fzf --prompt="Switch to session: " --height=40% --reverse --preview="tmux list-windows -t {1} -F '  #{window_index}: #{window_name}'" | \
    cut -d: -f1)

  if [ -n "$session" ]; then
    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session"
    else
      tmux attach-session -t "$session"
    fi
  fi
}

function gbclone() {
  if ! command -v git &>/dev/null; then
    echo "error: git is required but not installed" >&2
    return 1
  fi
  local repo_url
  repo_url=$1
  if [ -z "${repo_url}" ]; then
    echo "error: gbclone requires REPO_URL argument" >&2
    return 1
  fi
  local default_branch
  default_branch=$2
  default_branch="${default_branch:-main}"
  local repo
  repo=$(basename "${repo_url}" .git)
  if [ -d "${repo}" ]; then
    echo "error: ${repo}/ folder already exists" >&2
    return 1
  fi
  git clone --bare --branch "${default_branch}" --single-branch "${repo_url}" "${repo}" || return 1
  pushd "${repo}" 2>&1 >/dev/null || return 1
  git config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*' || return 1
  git fetch origin || return 1
  # checkout default branch with tracking
  git worktree add "branches/${default_branch}" "${default_branch}"
  pushd "branches/${default_branch}" 2>&1 >/dev/null || return 1
  git branch --set-upstream-to "origin/${default_branch}" "${default_branch}" || return 1
  popd >/dev/null
}

function gwtswitch() {
  if ! command -v git &>/dev/null; then
    echo "error: git is required but not installed" >&2
    return 1
  fi
  if ! command -v fzf &>/dev/null; then
    echo "error: fzf is required but not installed" >&2
    return 1
  fi
  local repo_root
  repo_root=$(git rev-parse --path-format=absolute --git-common-dir 2>/dev/null)
  if [ -z "${repo_root}" ]; then
    echo "error: cannot locate bare Git repository" >&2
    return 1
  fi
  cd "${repo_root}/" || return 1
  git fetch origin || return 1
  local branch
  branch=$(git branch -r | grep -v HEAD | sed 's|origin/||' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | fzf --print-query --prompt="Choose remote branch: " --height=40% --reverse | tail -1)
  if [ -z "${branch}" ]; then
    echo "operation cancelled"
    return 0
  fi
  local branch_path
  branch_path="branches/${branch}"
  if [ -d "${branch_path}" ]; then
    echo "navigating to existing worktree ..."
    cd "${branch_path}/" || return 1
    git status || return 1
    return 0
  fi
  if git show-ref --verify --quiet "refs/remotes/origin/${branch}"; then
    # remote branch exists
    git worktree add "${branch_path}" "${branch}" || return 1
    cd "${branch_path}/" || return 1
  else
    # no remote branch
    if git show-ref --verify --quiet "refs/heads/${branch}"; then
      # local branch exists
      git worktree add "${branch_path}" "${branch}" || return 1
    else
    # no local branch -> create one
      git worktree add -b "${branch}" "${branch_path}" || return 1
    fi
    cd "${branch_path}/" || return 1
    git push -u origin "${branch}" || return 1
  fi
  git status
}

function gwtcd() {
  local selection worktree
  selection=$(git worktree list | grep -v '(bare)' | fzf --height=40% --reverse --prompt="Select worktree: ")
  if [[ -n "$selection" ]]; then
    worktree=$(echo "$selection" | awk '{print $1}')
    cd "$worktree" || return 1
  fi
}

export RPROMPT='$(kube_ps1 | tr -d "()" | sed "s/|/ | /") :: %F{green}$NIX_FLAKE_NAME%f'
