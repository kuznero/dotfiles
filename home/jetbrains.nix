{ pkgs, ... }:

{
  home.packages = with pkgs; [ jetbrains.goland ];
}
