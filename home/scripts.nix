{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "gcauto" (builtins.readFile ./scripts/gcauto))
    (writeShellScriptBin "greview" (builtins.readFile ./scripts/greview))
    (writeShellScriptBin "gsreset" (builtins.readFile ./scripts/gsreset))
  ];
}
