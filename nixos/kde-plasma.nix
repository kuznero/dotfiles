{ lib, pkgs, ... }:

{
  # ref: https://wiki.nixos.org/wiki/KDE

  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings.General.DisplayServer = "wayland";
  services.desktopManager.plasma6.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals =
      [ pkgs.kdePackages.xdg-desktop-portal-kde pkgs.xdg-desktop-portal-gtk ];
  };
}
