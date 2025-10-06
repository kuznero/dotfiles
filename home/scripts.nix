{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "gcauto" (builtins.readFile ./scripts/gcauto))
  ];
}