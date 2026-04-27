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
    WINDOWS=("ops" "src")
    for name in "${WINDOWS[@]}"; do
      COUNTER=$((COUNTER+1))
      tmux new-window -t "$SESSION:$COUNTER" -n "$name" "$COMMAND"
    done

    tmux select-window -t "$SESSION:1"
    tmux rename-window -t "$SESSION:1" "butler"

    # Send nix develop to all windows if flake.nix exists and --nonix not set
    if [ "$USE_NIX" = true ] && [ -f "flake.nix" ]; then
      tmux send-keys -t "$SESSION:1" "nix develop" C-m
      tmux send-keys -t "$SESSION:1" "clear" C-m
      tmux send-keys -t "$SESSION:2" "nix develop" C-m
      tmux send-keys -t "$SESSION:2" "clear" C-m
      tmux send-keys -t "$SESSION:3" "nix develop" C-m
      tmux send-keys -t "$SESSION:3" "clear" C-m
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
  WINDOWS=("ops" "src")
  for name in "${WINDOWS[@]}"; do
    COUNTER=$((COUNTER+1))
    tmux new-window -t "$SESSION:$COUNTER" -n "$name" "$COMMAND"
  done

  tmux select-window -t "$SESSION:1"
  tmux rename-window -t "$SESSION:1" "butler"

  # Send nix develop to all windows if flake.nix exists and --nonix not set
  if [ "$USE_NIX" = true ] && [ -f "flake.nix" ]; then
    tmux send-keys -t "$SESSION:1" "nix develop" C-m
    tmux send-keys -t "$SESSION:1" "clear" C-m
    tmux send-keys -t "$SESSION:2" "nix develop" C-m
    tmux send-keys -t "$SESSION:2" "clear" C-m
    tmux send-keys -t "$SESSION:3" "nix develop" C-m
    tmux send-keys -t "$SESSION:3" "clear" C-m
  fi

  tmux attach-session -t "$SESSION"
}

function ts() {
  local current_branch=""
  local current_repo_name=""
  local terminal_cols fzf_width fzf_height fzf_left fzf_right

  terminal_cols=$(tput cols 2>/dev/null || echo 100)
  fzf_width=100
  fzf_height=20
  fzf_left=$(( (terminal_cols - fzf_width) / 2 ))
  fzf_right=$fzf_left

  if [ "$fzf_left" -lt 0 ]; then
    fzf_left=0
    fzf_right=0
  fi

  if git -C "$PWD" rev-parse --git-dir >/dev/null 2>&1; then
    current_branch=$(git -C "$PWD" branch --show-current 2>/dev/null || true)
    current_origin_url=$(git -C "$PWD" remote get-url origin 2>/dev/null || true)
    current_repo_name="${current_origin_url##*/}"
    current_repo_name="${current_repo_name%.git}"
  fi

  local selection
  selection=$(tmux list-panes -a -F '#{session_id}	#{window_id}	#{pane_id}	#{session_name}:#{window_index}.#{pane_index}	#{window_name}	#{pane_current_path}' 2>/dev/null |
    while IFS=$'\t' read -r session_id window_id pane_id session_label window_name pane_path; do
      local branch=""
      local repo_name=""

      if git -C "$pane_path" rev-parse --git-dir >/dev/null 2>&1; then
        branch=$(git -C "$pane_path" branch --show-current 2>/dev/null || true)
        origin_url=$(git -C "$pane_path" remote get-url origin 2>/dev/null || true)
        repo_name="${origin_url##*/}"
        repo_name="${repo_name%.git}"
      fi

      printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\n' "$session_id" "$window_id" "$pane_id" "$session_label" "$window_name" "$branch" "$repo_name"
    done |
    awk -F '\t' -v current_branch="$current_branch" -v current_repo_name="$current_repo_name" '
      function truncate(value, width) {
        if (length(value) <= width) {
          return value
        }

        return substr(value, 1, width - 3) "..."
      }

      BEGIN { OFS = "\t" }

      $5 == "butler" {
        current_marker = ($7 != "" && $7 == current_repo_name && $6 != "" && $6 == current_branch) ? "*" : ""
        printf "%s\t%s\t%s\t%-1s | %-20s | %-47s\n", $1, $2, $3, current_marker, truncate($7, 20), truncate($6, 47)
      }
    ' |
    fzf \
      --no-color \
      --prompt='tmux> ' \
      --delimiter=$'\t' \
      --with-nth=4 \
      --layout=reverse \
      --height="$fzf_height" \
      --margin="0,$fzf_right,0,$fzf_left" \
      --border)

  if [ -n "$selection" ]; then
    local session_id window_id pane_id
    IFS=$'\t' read -r session_id window_id pane_id _ <<< "$selection"

    if [ -n "$TMUX" ]; then
      tmux switch-client -t "$session_id"
      tmux select-window -t "$window_id"
      tmux select-pane -t "$pane_id"
    else
      tmux select-window -t "$window_id"
      tmux select-pane -t "$pane_id"
      tmux attach-session -t "$session_id"
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
  branch=$(git branch -r | grep -v HEAD | sed 's|origin/||' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | fzf --no-color --print-query --prompt="Choose remote branch: " --height=40% --reverse | tail -1)
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
  selection=$(git worktree list | grep -v '(bare)' | awk '{
    path=$1
    branch=$NF
    gsub(/[\[\]]/, "", branch)
    print branch "\t" path
  }' | fzf --no-color --height=40% --reverse --prompt="Worktree: " --with-nth=1)
  if [[ -n "$selection" ]]; then
    worktree=$(echo "$selection" | cut -f2)
    cd "$worktree" || return 1
  fi
}
