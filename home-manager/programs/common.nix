{ pkgs, pkgs-stable, ... }:

{
  home.packages = with pkgs;
    [
      btop
      cmatrix
      fd
      ffmpegthumbnailer
      fish
      flux
      gitFull
      gnupg
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
      wl-clipboard
      xclip
      zoxide
      zsh
    ] ++ (with pkgs-stable; [ yazi ]);
}
