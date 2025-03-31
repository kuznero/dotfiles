{ pkgs, ... }:

{
  home.file = {
    ".config/dunst" = {
      source = ./dotfiles/dunst;
      recursive = true;
    };
    ".config/fish" = {
      source = ./dotfiles/fish;
      recursive = true;
    };
    ".config/gtk-3.0" = {
      source = ./dotfiles/gtk-3.0;
      recursive = true;
    };
    ".config/gtk-4.0" = {
      source = ./dotfiles/gtk-4.0;
      recursive = true;
    };
    ".config/hypr" = {
      source = ./dotfiles/hypr;
      recursive = true;
    };
    ".config/rofi" = {
      source = ./dotfiles/rofi;
      recursive = true;
    };
    ".config/wallpapers" = {
      source = ./dotfiles/wallpapers;
      recursive = true;
    };
    ".config/waybar" = {
      source = ./dotfiles/waybar;
      recursive = true;
    };
    ".config/wlogout" = {
      source = ./dotfiles/wlogout;
      recursive = true;
    };
    ".config/xfce4" = {
      source = ./dotfiles/xfce4;
      recursive = true;
    };
    ".config/xsettingsd" = {
      source = ./dotfiles/xsettingsd;
      recursive = true;
    };
    ".config/yazi" = {
      source = ./dotfiles/yazi;
      recursive = true;
    };
  };
}
