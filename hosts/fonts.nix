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
    packages = with pkgs; [
      font-awesome
      iosevka
      jetbrains-mono
      monaspace
      montserrat
      # nerdfonts
      poppins
      source-sans-pro
      source-serif-pro
      nerd-fonts.space-mono
    ];
  };
}
