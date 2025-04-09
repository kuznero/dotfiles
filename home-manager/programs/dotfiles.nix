{ pkgs, ... }:

{
  home.file = {
    ".config/dunst" = {
      source = ./dotfiles/config/dunst;
      recursive = true;
    };
    ".config/fish" = {
      source = ./dotfiles/config/fish;
      recursive = true;
    };
    ".config/gtk-3.0" = {
      source = ./dotfiles/config/gtk-3.0;
      recursive = true;
    };
    ".config/gtk-4.0" = {
      source = ./dotfiles/config/gtk-4.0;
      recursive = true;
    };
    ".config/hypr" = {
      source = ./dotfiles/config/hypr;
      recursive = true;
    };
    ".config/rofi" = {
      source = ./dotfiles/config/rofi;
      recursive = true;
    };
    ".config/wallpapers" = {
      source = ./dotfiles/config/wallpapers;
      recursive = true;
    };
    ".config/waybar" = {
      source = ./dotfiles/config/waybar;
      recursive = true;
    };
    ".config/wlogout" = {
      source = ./dotfiles/config/wlogout;
      recursive = true;
    };
    ".config/xsettingsd" = {
      source = ./dotfiles/config/xsettingsd;
      recursive = true;
    };
    ".config/yazi" = {
      source = ./dotfiles/config/yazi;
      recursive = true;
    };
    ".local/share/xfce4/terminal/colorschemes" = {
      source = ./dotfiles/local/share/xfce4/terminal/colorschemes;
      recursive = true;
    };
  };
}
