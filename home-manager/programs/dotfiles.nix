{ pkgs, ... }:

{
  home.file = {
    ".config/k9s" = {
      source = ./dotfiles/config/k9s;
      recursive = true;
    };
    ".config/wallpapers" = {
      source = ./dotfiles/config/wallpapers;
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
