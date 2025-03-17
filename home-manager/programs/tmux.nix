{ inputs, pkgs, ... }:

{
  catppuccin.tmux = {
    enable = true;
    flavor = "frappe";
    extraConfig = ''
      set -g @catppuccin_window_status_style "rounded"
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
      # Rename window with prefix + r
      bind r command-prompt -I "#W" "rename-window '%%'"

      # Reload tmux config by pressing prefix + 
      bind R source-file ~/.config/tmux/tmux.conf \; display "Configuration reloaded"

      # Toggles to sync panes
      bind e setw synchronize-panes on \; display "Sync is ON"
      bind E setw synchronize-panes off \; display "Sync is OFF"

      # Apply Tc
      set -ga terminal-overrides ",xterm-256color:RGB:smcup@:rmcup@"

      # Enable focus-events
      set -g focus-events on

      # Set default escape-time
      set-option -sg escape-time 10
    '';
  };

}
