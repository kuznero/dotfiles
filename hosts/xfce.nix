{ lib, pkgs, ... }:

{
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        enableScreensaver = false;
      };
    };
    displayManager.lightdm.enable = true;
  };

  services.displayManager.defaultSession = "xfce";
}
