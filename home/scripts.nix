{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    (writeShellScriptBin "configure-ollama-opencode" (builtins.readFile ./scripts/configure-ollama-opencode))
    (writeShellScriptBin "configure-ollama-tailscale" (builtins.readFile ./scripts/configure-ollama-tailscale))
    (writeShellScriptBin "gcauto" (builtins.readFile ./scripts/gcauto))
    (writeShellScriptBin "greview" (builtins.readFile ./scripts/greview))
    (writeShellScriptBin "gsreset" (builtins.readFile ./scripts/gsreset))
  ];
}
