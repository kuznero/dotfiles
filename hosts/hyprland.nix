{ lib, pkgs, ... }:

{
  # ref: https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/tree/main

  programs.hyprland = {
    enable = true;
    package = pkgs.hyprland;
    xwayland.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  environment.systemPackages = with pkgs; [
    brightnessctl
    direnv
    dunst
    fish
    hyprcursor
    hypridle
    hyprlock
    hyprpaper
    hyprpicker
    kitty
    pamixer
    pavucontrol
    playerctl
    psmisc
    pyprland
    rofi
    starship
    waybar
    wezterm
    wlsunset
    wofi
  ];
}
