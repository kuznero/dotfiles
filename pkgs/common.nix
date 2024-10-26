{ pkgs, ... }:

let
  patchelfFixed = pkgs.patchelfUnstable.overrideAttrs (_finalAttrs: _previousAttrs: {
    src = pkgs.fetchFromGitHub {
      owner = "Patryk27";
      repo = "patchelf";
      rev = "527926dd9d7f1468aa12f56afe6dcc976941fedb";
      sha256 = "sha256-3I089F2kgGMidR4hntxz5CKzZh5xoiUwUsUwLFUEXqE=";
    };
  });

  pcloudFixed = pkgs.pcloud.overrideAttrs (_finalAttrs:previousAttrs: {
    nativeBuildInputs = previousAttrs.nativeBuildInputs ++ [ patchelfFixed ];
  });
in
{
  environment.systemPackages = with pkgs; [
    btop
    copyq
    docker-credential-helpers
    fd
    gitFull
    home-manager
    kitty
    neofetch
    obsidian
    pcloudFixed
    ripgrep
    slack
    spotify
    telegram-desktop
    tmux
    vim
    xclip
    zoom-us
  ];
}
