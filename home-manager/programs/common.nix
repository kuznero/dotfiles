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
      go-task
      k9s
      kubectl
      kubectx
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
      tree
      vim
      wl-clipboard
      xclip
      zoxide
      zsh
    ] ++ (with pkgs-stable; [ yazi ]);
}
