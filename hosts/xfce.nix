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
    displayManager.lightdm.enable = true;
  };

  services.displayManager.defaultSession = "xfce";
}
