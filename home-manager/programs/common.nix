{ pkgs, pkgs-stable, system, ... }:

{
  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      btop
      cmatrix
      fd
      ffmpegthumbnailer
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
      pass
      podman
      podman-compose
      podman-tui
      poppler
      ripgrep
      rsync
      tmux
      tree
      vim
      xclip
      zoxide
      zsh
    ] ++ (with pkgs-stable; [ yazi ]);
}
