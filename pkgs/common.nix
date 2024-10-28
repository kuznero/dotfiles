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
    docker-credential-helpers
    fd
    fish
    gitFull
    home-manager
    kitty
    neofetch
    obsidian
    ripgrep
    rsync
    slack
    spotify
    tmux
    tree
    vim
    xclip
    zoom-us
  ] ++ lib.optionals (!stdenv.isDarwin) [
    copyq
    pcloudFixed
    telegram-desktop
  ];
}
