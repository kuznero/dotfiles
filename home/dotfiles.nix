{ pkgs, ... }:

{
  home.file = {
    ".local/share/zsh-custom/themes" = {
      source = ./dotfiles/zsh-custom/themes;
      recursive = true;
      force = true;
    };
    ".config/ghostty/themes" = {
      source = ./dotfiles/config/ghostty/themes;
      recursive = true;
      force = true;
    };
    ".config/k9s" = {
      source = ./dotfiles/config/k9s;
      recursive = true;
      force = true;
    };
    "Library/Application Support/k9s" = {
      source = ./dotfiles/config/k9s;
      recursive = true;
      force = true;
    };
    ".config/mc" = {
      source = ./dotfiles/config/mc;
      recursive = true;
      force = true;
    };
    ".config/yazi" = {
      source = ./dotfiles/config/yazi;
      recursive = true;
      force = true;
    };
  };
}
