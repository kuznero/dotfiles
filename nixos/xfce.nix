{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    evince
    lightlocker # Session-locker for XFCE workaround
    xfce.ristretto
    xfce.thunar
    xfce.thunar-archive-plugin
    xfce.thunar-volman
    xfce.xfce4-icon-theme
    xfce.xfwm4-themes
  ];

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        enableScreensaver = true;
      };
    };
    displayManager.lightdm = {
      enable = true;
      extraConfig = ''
        display-setup-script=${pkgs.xorg.xrandr}/bin/xrandr --output eDP-1 --auto --output DP-3-1-8 --primary --left-of eDP-1 --auto
      '';
    };
  };

  services.displayManager.defaultSession = "xfce";
}
