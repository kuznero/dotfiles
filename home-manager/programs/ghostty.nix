{ inputs, pkgs, system, theme ? "dark:catppuccin-mocha,light:catppuccin-latte"
, fontFamily ? "Hurmit Nerd Font", fontSize ? "12", adjustCellHeight ? "-20%"
, ... }:

let
  configFile = if builtins.match ".*-darwin" system != null then
    "./Library/Application Support/com.mitchellh.ghostty/config"
  else if builtins.match ".*-linux" system != null then
    "./.config/ghostty/config"
  else
    "./.config/ghostty/config";
in {
  home.packages = with inputs;
    builtins.filter (pkg: pkg != null) [
      (if system == "x86_64-linux" then
        ghostty.packages."${system}".default
      else
        null)
    ];
  home.file."${configFile}".text = ''
    theme = ${theme}
    font-family = ${fontFamily}
    font-size = ${fontSize}
    font-style-bold = false
    adjust-cell-height = ${adjustCellHeight}
    shell-integration-features = no-cursor
    cursor-style = block
    mouse-hide-while-typing = true
    macos-option-as-alt = true
  '';
}
