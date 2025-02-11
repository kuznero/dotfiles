{ inputs, pkgs, system, theme ? "dark:catppuccin-mocha,light:catppuccin-latte"
, fontFamily ? "SpaceMono Nerd Font", fontSize ? "12", ... }:

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
    shell-integration-features = no-cursor
    cursor-style = block
    background-opacity = 0.8
  '';
}
