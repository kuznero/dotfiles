{ pkgs, pkgs-stable, system, ... }:

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
    (if system != "aarch64-linux" then slack else null)
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

