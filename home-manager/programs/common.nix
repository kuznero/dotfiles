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
      lazydocker
      lazygit
      neofetch
      nerd-fonts.envy-code-r
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka-term-slab
      nerd-fonts.jetbrains-mono
      nerd-fonts.lekton
      nerd-fonts.meslo-lg
      nerd-fonts.monaspace
      nerd-fonts.monofur
      nerd-fonts.mononoki
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.ubuntu-sans
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
