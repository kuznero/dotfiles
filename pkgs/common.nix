{ pkgs, ... }:

let
  # # sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # # sudo nix-channel --update
  # unstable = import <nixos-unstable> {
  #   config = {
  #     allowUnfree = true;
  #   };
  # };

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
    docker-credential-helpers
    gitFull
    home-manager
    kitty
    obsidian
    pcloudFixed
    slack
    spotify
    telegram-desktop
    vim

    # copyq
    # unstable.bcompare
    # unstable.talosctl
    # zoom-us
  ];
}
