{ pkgs, system, ... }:

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
  home.packages = with pkgs; builtins.filter (pkg: pkg != null) [
    (if system == "x86_64-linux" then pcloudFixed else null)
  ];
}

