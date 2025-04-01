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
    at-spi2-atk
    avizo
    brightnessctl
    cliphist
    direnv
    dunst
    ffmpeg_6-full
    fish
    gifsicle
    grim
    hyprcursor
    hypridle
    hyprlock
    hyprpaper
    hyprpicker
    imagemagick
    kitty
    pamixer
    pavucontrol
    playerctl
    poweralertd
    psi-notify
    psmisc
    pyprland
    qt6.qtwayland
    rofi
    rofi-wayland
    slurp
    starship
    swappy
    waybar
    wezterm
    wl-clip-persist
    wl-clipboard
    wl-screenrec
    wlogout
    wlrctl
    wlsunset
    wofi
    wtype
    xdg-utils
  ];
}
