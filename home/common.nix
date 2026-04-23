{ pkgs, pkgs-stable, ... }:

{
  home.packages = with pkgs;
    [
      bat
      btop
      cmatrix
      coreutils-full
      eza
      fd
      ffmpegthumbnailer
      gcc
      git
      git-town
      gnupg
      go-task
      kubectl
      kubeswitch
      lazydocker
      lazygit
      mc
      nodejs_24
      pass
      poppler
      ripgrep
      rsync
      tree
      tree-sitter
      vim
      wget
      zsh
    ] ++ builtins.attrValues (pkgs.lib.filterAttrs (_: v: pkgs.lib.isDerivation v) pkgs.nerd-fonts)
    ++ (with pkgs-stable; [ yazi ])
    ++ pkgs.lib.optional pkgs.stdenv.hostPlatform.isLinux xclip;
}
