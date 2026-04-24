{ pkgs, ... }:

let
  tmuxSessionPicker = pkgs.writeShellScriptBin "tmux-session-picker" ''
    #!/usr/bin/env bash
    set -euo pipefail

    current_branch=""
    current_repo_name=""
    current_pane_path="$(tmux display-message -p '#{pane_current_path}')"

    if git -C "$current_pane_path" rev-parse --git-dir >/dev/null 2>&1; then
      current_branch=$(git -C "$current_pane_path" branch --show-current 2>/dev/null || true)
      current_origin_url=$(git -C "$current_pane_path" remote get-url origin 2>/dev/null || true)
      current_repo_name="''${current_origin_url##*/}"
      current_repo_name="''${current_repo_name%.git}"
    fi

    selection="$({
      tmux list-panes -a -F '#{session_id}	#{window_id}	#{pane_id}	#{session_name}:#{window_index}.#{pane_index}	#{window_name}	#{pane_current_path}' |
        while IFS=$'\t' read -r session_id window_id pane_id session_label window_name pane_path; do
          branch=""
          repo_name=""

          if git -C "$pane_path" rev-parse --git-dir >/dev/null 2>&1; then
            branch=$(git -C "$pane_path" branch --show-current 2>/dev/null || true)
            origin_url=$(git -C "$pane_path" remote get-url origin 2>/dev/null || true)
            repo_name="''${origin_url##*/}"
            repo_name="''${repo_name%.git}"
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
          --height=100%
    } || true)"

    [ -n "''${selection}" ] || exit 0

    IFS=$'\t' read -r session_id window_id pane_id display_value <<< "''${selection}"

    case "$display_value" in
      \**)
        exit 0
        ;;
    esac

    tmux switch-client -t "''${session_id}"
    tmux select-window -t "''${window_id}"
    tmux select-pane -t "''${pane_id}"
  '';

  tmuxApplyAppearance = pkgs.writeShellScriptBin "tmux-apply-appearance" ''
    #!/usr/bin/env bash
    set -euo pipefail

    appearance_file="$HOME/.config/appearance"
    appearance="light"

    if [ -f "$appearance_file" ]; then
      appearance_value="$(tr -d '\r' < "$appearance_file" | head -n 1)"

      case "$appearance_value" in
        dark)
          appearance="dark"
          ;;
        light)
          appearance="light"
          ;;
        mocha)
          appearance="dark"
          printf 'dark\n' > "$appearance_file"
          ;;
        latte)
          appearance="light"
          printf 'light\n' > "$appearance_file"
          ;;
        *)
          printf 'light\n' > "$appearance_file"
          ;;
      esac
    else
      mkdir -p "$HOME/.config"
      printf 'light\n' > "$appearance_file"
    fi

    if [ "$appearance" = "dark" ]; then
      tmux set-option -g status-style "bg=#0f172a,fg=#cbd5e1"
      tmux set-option -g mode-style "bg=#f59e0b,fg=#0f172a"
      tmux set-option -g message-style "bg=#1e293b,fg=#e2e8f0"
      tmux set-option -g message-command-style "bg=#2dd4bf,fg=#0f172a"
      tmux set-option -g pane-border-style "fg=#334155"
      tmux set-option -g pane-active-border-style "fg=#2dd4bf"
      tmux set-option -g display-panes-colour "#94a3b8"
      tmux set-option -g display-panes-active-colour "#f59e0b"
      tmux set-option -g popup-style "bg=#111827,fg=#cbd5e1"
      tmux set-option -g popup-border-style "fg=#2dd4bf"
      tmux set-option -g window-status-format " #[fg=#94a3b8,bg=#1e293b] #I:#W "
      tmux set-option -g window-status-current-format " #[fg=#0f172a,bg=#2dd4bf,bold] #I:#W "
      tmux set-option -g window-status-last-style "fg=#f59e0b"
      tmux set-option -g window-status-activity-style "fg=#f59e0b,bold"
      tmux set-option -g status-right "#{?client_prefix,#[fg=#0f172a,bg=#f59e0b,bold] PREFIX ,}#[fg=#e2e8f0,bg=#1e293b] #S #[fg=#0f172a,bg=#2dd4bf] %a %H:%M "
    else
      tmux set-option -g status-style "bg=#e8eef5,fg=#334155"
      tmux set-option -g mode-style "bg=#d97706,fg=#fff7ed"
      tmux set-option -g message-style "bg=#dbe4f0,fg=#1e293b"
      tmux set-option -g message-command-style "bg=#0f766e,fg=#f8fafc"
      tmux set-option -g pane-border-style "fg=#cbd5e1"
      tmux set-option -g pane-active-border-style "fg=#0f766e"
      tmux set-option -g display-panes-colour "#64748b"
      tmux set-option -g display-panes-active-colour "#d97706"
      tmux set-option -g popup-style "bg=#f8fafc,fg=#334155"
      tmux set-option -g popup-border-style "fg=#0f766e"
      tmux set-option -g window-status-format " #[fg=#64748b,bg=#dbe4f0] #I:#W "
      tmux set-option -g window-status-current-format " #[fg=#f8fafc,bg=#0f766e,bold] #I:#W "
      tmux set-option -g window-status-last-style "fg=#b45309"
      tmux set-option -g window-status-activity-style "fg=#b45309,bold"
      tmux set-option -g status-right "#{?client_prefix,#[fg=#fff7ed,bg=#d97706,bold] PREFIX ,}#[fg=#1e293b,bg=#dbe4f0] #S #[fg=#f8fafc,bg=#0f766e] %a %H:%M "
    fi
  '';

  tmuxToggleAppearance = pkgs.writeShellScriptBin "tmux-toggle-appearance" ''
    #!/usr/bin/env bash
    set -euo pipefail

    appearance_file="$HOME/.config/appearance"
    appearance="light"

    mkdir -p "$HOME/.config"

    if [ -f "$appearance_file" ]; then
      IFS= read -r appearance_value < "$appearance_file" || appearance_value=""

      case "$appearance_value" in
        dark|mocha)
          appearance="dark"
          ;;
        light|latte)
          appearance="light"
          ;;
      esac
    fi

    if [ "$appearance" = "dark" ]; then
      next_appearance="light"
    else
      next_appearance="dark"
    fi

    printf '%s\n' "$next_appearance" > "$appearance_file"

    if [ -n "''${TMUX:-}" ]; then
      "${tmuxApplyAppearance}/bin/tmux-apply-appearance"
      tmux display-message "Appearance: $next_appearance"
    fi
  '';
in {
  home.packages =
    [ tmuxSessionPicker tmuxApplyAppearance tmuxToggleAppearance ];

  programs.tmux = {
    enable = true;
    baseIndex = 1;

    escapeTime = 10;
    historyLimit = 10000;
    keyMode = "vi";
    mouse = true;
    sensibleOnTop = false;
    terminal = "tmux-256color";

    extraConfig = ''
      # Mouse wheel scrolling - scroll 1 line at a time
      bind -T copy-mode-vi WheelUpPane send-keys -X -N 1 scroll-up
      bind -T copy-mode-vi WheelDownPane send-keys -X -N 1 scroll-down
      bind -T copy-mode WheelUpPane send-keys -X -N 1 scroll-up
      bind -T copy-mode WheelDownPane send-keys -X -N 1 scroll-down

      # Rename window
      bind -n M-r command-prompt -I "#W" "rename-window '%%'"

      # Reload tmux config
      bind -n M-R source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded"

      # Fuzzy picker for jumping across sessions/windows/panes
      bind -n M-p display-popup -E -B -w 100 -h 20 -x C -y C "${tmuxSessionPicker}/bin/tmux-session-picker"

      # Easy navigation
      bind -n M-Left run-shell "if [ $(tmux display-message -p '#{pane_at_left}') -ne 1 ]; then tmux select-pane -L; else tmux select-window -p; fi"
      bind -n M-h run-shell "if [ $(tmux display-message -p '#{pane_at_left}') -ne 1 ]; then tmux select-pane -L; else tmux select-window -p; fi"
      bind -n M-Right run-shell "if [ $(tmux display-message -p '#{pane_at_right}') -ne 1 ]; then tmux select-pane -R; else tmux select-window -n; fi"
      bind -n M-l run-shell "if [ $(tmux display-message -p '#{pane_at_right}') -ne 1 ]; then tmux select-pane -R; else tmux select-window -n; fi"
      bind -n M-Down run-shell "if [ $(tmux display-message -p '#{pane_at_bottom}') -ne 1 ]; then tmux select-pane -D; fi"
      bind -n M-j run-shell "if [ $(tmux display-message -p '#{pane_at_bottom}') -ne 1 ]; then tmux select-pane -D; fi"
      bind -n M-Up run-shell "if [ $(tmux display-message -p '#{pane_at_top}') -ne 1 ]; then tmux select-pane -U; fi"
      bind -n M-k run-shell "if [ $(tmux display-message -p '#{pane_at_top}') -ne 1 ]; then tmux select-pane -U; fi"
      bind -n M-n run-shell "tmux new-window"
      bind -n M-t run-shell "${tmuxToggleAppearance}/bin/tmux-toggle-appearance"
      bind -n M-z run-shell "tmux resize-pane -Z"

      # Toggles to sync panes
      bind -n M-e setw synchronize-panes on \; display "Sync is ON"
      bind -n M-E setw synchronize-panes off \; display "Sync is OFF"

      # Apply Tc
      set -ga terminal-overrides ",xterm-256color:RGB:smcup@:rmcup@"

      # Enable focus-events
      set -g focus-events on

      # Set default escape-time
      set-option -sg escape-time 10

      # Shared tmux layout; colors are loaded from ~/.config/appearance.
      set-option -g status-position top
      set-option -g status-interval 5
      set-option -g status-justify left

      set-option -g window-status-separator ""

      set-option -g status-left ""
      set-option -g status-right-length 100
      set-option -g status-left-length 100

      run-shell "${tmuxApplyAppearance}/bin/tmux-apply-appearance"
    '';
  };

}
