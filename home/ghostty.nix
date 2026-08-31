{ lib, system, ... }:

let
  isDarwin = builtins.match ".*-darwin" system != null;

  ghosttyConfig = ''
    theme = dark:GitHub Dark Default,light:GitHub Light Default
    font-family =
    # font-family = Agave Nerd Font
    # font-family = AtkynsonMono Nerd Font
    font-family = MartianMono Nerd Font
    font-size = 12
    font-style-bold = false
    adjust-cell-height = 5%
    adjust-cell-width = 0%
    # Use the widely-available xterm-256color instead of xterm-ghostty so that
    # remote servers over SSH work without installing custom terminfo entries.
    term = xterm-256color
    shell-integration-features = no-cursor
    cursor-style = block
    mouse-hide-while-typing = true
    mouse-scroll-multiplier = 1.0
    macos-option-as-alt = true
    maximize = true
  '';
in {
  xdg.configFile."ghostty/config".text = ghosttyConfig;

  home.file."Library/Application Support/com.mitchellh.ghostty/config" =
    lib.mkIf isDarwin { text = ghosttyConfig; };
}
