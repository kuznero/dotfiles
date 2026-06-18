{ lib, system, ... }:

let
  isDarwin = builtins.match ".*-darwin" system != null;

  ghosttyConfig = ''
    theme = dark:GitHub Dark Default,light:GitHub Light Default
    font-family = RecMonoCasual Nerd Font
    font-size = 14
    font-style-bold = false
    adjust-cell-height = 10%
    adjust-cell-width = 0%
    shell-integration-features = cursor,sudo,ssh-env,ssh-terminfo
    cursor-style = block
    mouse-hide-while-typing = true
    mouse-scroll-multiplier = 1.0
    macos-option-as-alt = true
  '';
in {
  xdg.configFile."ghostty/config".text = ghosttyConfig;

  home.file."Library/Application Support/com.mitchellh.ghostty/config" =
    lib.mkIf isDarwin { text = ghosttyConfig; };
}
