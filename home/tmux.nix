{ pkgs, config, lib, ... }:

let
  # Get the catppuccin plugin path from the Nix store
  catppuccinPluginPath = "${config.catppuccin.sources.tmux}/share/tmux-plugins/catppuccin";

  # Script to toggle between light and dark themes
  tmuxThemeToggle = pkgs.writeShellScriptBin "tmux-theme-toggle" ''
    #!/usr/bin/env bash

    APPEARANCE_FILE="$HOME/.config/appearance"

    # Initialize appearance file with latte if it doesn't exist
    if [ ! -f "$APPEARANCE_FILE" ]; then
      mkdir -p "$(dirname "$APPEARANCE_FILE")"
      echo "latte" > "$APPEARANCE_FILE"
    fi

    # Read current flavor from appearance file
    current_flavor=$(cat "$APPEARANCE_FILE")

    # Toggle between latte and mocha
    if [[ "$current_flavor" == "latte" ]]; then
      new_flavor="mocha"
    else
      new_flavor="latte"
    fi

    # Save the new theme to file for persistence
    echo "$new_flavor" > "$APPEARANCE_FILE"

    # Unset all theme color variables (they use -o flag so can't be overwritten)
    for var in thm_bg thm_fg thm_rosewater thm_flamingo thm_pink thm_mauve \
               thm_red thm_maroon thm_peach thm_yellow thm_green thm_teal \
               thm_sky thm_sapphire thm_blue thm_lavender thm_subtext_1 \
               thm_subtext_0 thm_overlay_2 thm_overlay_1 thm_overlay_0 \
               thm_surface_2 thm_surface_1 thm_surface_0 thm_mantle thm_crust; do
      tmux set-option -gu "@$var"
    done

    # Also unset status module text color variables
    for module in application cpu session uptime battery; do
      tmux set-option -gu "@catppuccin_status_''${module}_text_fg"
      tmux set-option -gu "@catppuccin_status_''${module}_icon_fg"
    done

    # Set the new flavor in tmux
    tmux set-option -g @catppuccin_flavor "$new_flavor"

    # Source just the theme config file
    # This reloads the theme based on the current @catppuccin_flavor value
    tmux source-file "${catppuccinPluginPath}/catppuccin_tmux.conf"
  '';

  tmuxSessionPicker = pkgs.writeShellScriptBin "tmux-session-picker" ''
    #!/usr/bin/env bash
    set -euo pipefail

    selection="$({
      tmux list-panes -a -F '#{session_id}	#{window_id}	#{pane_id}	#{session_name}:#{window_index}.#{pane_index}	#{window_name}	#{pane_current_path}' |
        while IFS=$'\t' read -r session_id window_id pane_id session_label window_name pane_path; do
          branch=""

          if git -C "$pane_path" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
            branch=$(git -C "$pane_path" branch --show-current 2>/dev/null || true)
          fi

          printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$session_id" "$window_id" "$pane_id" "$session_label" "$window_name" "$branch"
        done |
        awk -F '\t' '
          function truncate(value, width) {
            if (length(value) <= width) {
              return value
            }

            return substr(value, 1, width - 3) "..."
          }

          BEGIN { OFS = "\t" }

          {
            printf "%s\t%s\t%s\t%-32s | %-6s | %-50s\n", $1, $2, $3, truncate($6, 32), truncate($5, 6), truncate($4, 50)
          }
        ' |
        fzf \
          --no-color \
          --prompt='tmux> ' \
          --delimiter=$'\t' \
          --with-nth=4 \
          --layout=reverse \
          --height=100% \
          --border
    } || true)"

    [ -n "''${selection}" ] || exit 0

    IFS=$'\t' read -r session_id window_id pane_id _ <<< "''${selection}"

    tmux switch-client -t "''${session_id}"
    tmux select-window -t "''${window_id}"
    tmux select-pane -t "''${pane_id}"
  '';
in
{
  home.packages = [ tmuxThemeToggle tmuxSessionPicker ];

  catppuccin.tmux = {
    enable = true;
    flavor = "latte";
    extraConfig = ''
      # Load saved theme from appearance file if it exists
      run-shell 'if [ -f ~/.config/appearance ]; then tmux set-option -g @catppuccin_flavor "$(cat ~/.config/appearance)"; fi'

      set -g @catppuccin_window_status_style "basic"
      set -g @catppuccin_window_text " #W#{?window_zoomed_flag, ●,}"
      set -g @catppuccin_window_current_text " #W#{?window_zoomed_flag, ●,}"

      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -agF status-right "#{E:@catppuccin_status_battery}"
    '';
  };

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

      # Toggle theme (light/dark)
      bind -n M-t run-shell "${tmuxThemeToggle}/bin/tmux-theme-toggle"

      # Fuzzy picker for jumping across sessions/windows/panes
      bind -n M-p display-popup -E -w 90% -h 85% "${tmuxSessionPicker}/bin/tmux-session-picker"

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

      set-option -g status-position top
    '';
  };

}
