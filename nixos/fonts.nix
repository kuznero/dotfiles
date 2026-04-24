{ pkgs, ... }:

{
  fonts = {
    fontconfig = {
      enable = true;
      defaultFonts = {
        monospace = [ "Monaspace Neon" ];
        sansSerif = [ "Source Sans Pro" ];
        serif = [ "Source Serif Pro" ];
      };
    };
    enableDefaultPackages = true;
    fontDir.enable = true;
    packages = with pkgs;
      [
        font-awesome
        iosevka
        jetbrains-mono
        monaspace
        montserrat
        poppins
        source-sans-pro
        source-serif-pro
      ] ++ builtins.attrValues
      (pkgs.lib.filterAttrs (_: v: pkgs.lib.isDerivation v) pkgs.nerd-fonts);
  };
}
