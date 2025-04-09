{ lib, pkgs, ... }:

{
  environment.systemPackages = with pkgs;
    [
      lightlocker # Session-locker for XFCE workaround
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
