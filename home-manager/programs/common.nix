{ pkgs, pkgs-stable, ... }:

{
  home.packages = with pkgs; [
    btop
    docker-credential-helpers
    fd
    fish
    flux
    gitFull
    k9s
    kitty
    kubectl
    lazydocker
    lazygit
    neofetch
    nerdfonts
    ripgrep
    rsync
    slack
    spotify
    tmux
    tree
    vim
    xclip
    zoom-us
    zoxide
    zsh
  ] ++ (with pkgs-stable; [
    obsidian
  ]);
}

