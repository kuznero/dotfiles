{ pkgs, ... }:

{
  home.packages = with pkgs; [ yabai skhd ];
}
