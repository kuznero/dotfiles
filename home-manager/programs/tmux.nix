{ inputs, pkgs, ... }:

{
  catppuccin.tmux = {
    enable = true;
    flavor = "mocha";
    extraConfig = ''
      set -g @catppuccin_window_status_style "none"
      set -g @catppuccin_window_text " #W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text " #W"
      set -g status-right-length 100
      set -g status-left-length 100
      set -g status-left ""
      set -g status-right "#{E:@catppuccin_status_application}"
      set -agF status-right "#{E:@catppuccin_status_cpu}"
      set -ag status-right "#{E:@catppuccin_status_session}"
      set -ag status-right "#{E:@catppuccin_status_uptime}"
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
      # Rename window
      bind -n M-r command-prompt -I "#W" "rename-window '%%'"

      # Reload tmux config
      bind -n M-R source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded"

      # Easy navigation
      bind -n M-Left run-shell "if [ $(tmux display-message -p '#{pane_at_left}') -ne 1 ]; then tmux select-pane -L; else tmux select-window -p; fi"
      bind -n M-Right run-shell "if [ $(tmux display-message -p '#{pane_at_right}') -ne 1 ]; then tmux select-pane -R; else tmux select-window -n; fi"
      bind -n M-Down run-shell "if [ $(tmux display-message -p '#{pane_at_bottom}') -ne 1 ]; then tmux select-pane -D; fi"
      bind -n M-Up run-shell "if [ $(tmux display-message -p '#{pane_at_top}') -ne 1 ]; then tmux select-pane -U; fi"
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

      set-option -g status-position bottom
    '';
  };

}
