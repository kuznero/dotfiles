{ pkgs, system, ... }:

{
  home.packages = with pkgs; builtins.filter (pkg: pkg != null) [
    (if system != "aarch64-linux" then bcompare else null)
  ];
}

