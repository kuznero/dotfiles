{ pkgs, pkgs-stable, ... }:

{
  home.packages = with pkgs;
    [
      bat
      btop
      (pkgs.callPackage ../nixpkgs/claude-code { })
      (pkgs.callPackage ../nixpkgs/opencode { })
      cmatrix
      coreutils-full
      eza
      fd
      ffmpegthumbnailer
      fish
      flux
      gcc
      git
      git-town
      gnupg
      go-task
      (pkgs.callPackage ../nixpkgs/k9s { })
      kubectl
      kubeswitch
      lan-mouse
      lazydocker
      lazygit
      mc
      neofetch
      nerd-fonts._0xproto
      nerd-fonts.agave
      nerd-fonts.envy-code-r
      nerd-fonts.fantasque-sans-mono
      nerd-fonts.hurmit
      nerd-fonts.iosevka
      nerd-fonts.iosevka-term
      nerd-fonts.iosevka-term-slab
      nerd-fonts.jetbrains-mono
      nerd-fonts.lekton
      nerd-fonts.meslo-lg
      nerd-fonts.monaspace
      nerd-fonts.monofur
      nerd-fonts.mononoki
      nerd-fonts.space-mono
      nerd-fonts.ubuntu
      nerd-fonts.ubuntu-mono
      nerd-fonts.ubuntu-sans
      nerd-fonts.zed-mono
      nodejs_24
      pass
      poppler
      ripgrep
      rsync
      tree
      tree-sitter
      tt
      vim
      wget
      xclip
      zoxide
      zsh
    ] ++ (with pkgs-stable; [ yazi ]);
}
