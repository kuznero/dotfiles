{ inputs
, pkgs
, system
, theme ? "catppuccin-mocha"
, fontFamily ? "Hurmit Nerd Font"
, fontSize ? "12"
, ...
}:

let
  configFile =
    if builtins.match ".*-darwin" system != null then
      "./Library/Application Support/com.mitchellh.ghostty/config"
    else if builtins.match ".*-linux" system != null then
      "./.config/ghostty/config"
    else
      "./.config/ghostty/config";
in
{
  home.packages = with inputs; [ ghostty.packages.x86_64-linux.default ];
  home.file."${configFile}".text = ''
    theme = ${theme}
    font-family = ${fontFamily}
    font-size = ${fontSize}
    shell-integration-features = no-cursor
    cursor-style = block
  '';
}
