{ pkgs, pkgs-stable, system, ... }:

{
  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      btop
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
      obsidian
      podman
      podman-compose
      podman-tui
      poppler
      ripgrep
      rsync
      (if system != "aarch64-linux" then slack else null)
      (if system != "aarch64-linux" then spotify else null)
      tmux
      tree
      vim
      xclip
      (if system != "aarch64-linux" then zoom-us else null)
      zoxide
      zsh
    ] ++ (with pkgs-stable; [ yazi ]);
}
