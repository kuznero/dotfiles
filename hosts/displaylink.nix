{ config, lib, nixpkgs, home-manager, ... }:

{
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];
  # nix-prefetch-url --name displaylink-600.zip https://www.synaptics.com/sites/default/files/exe_files/2024-05/DisplayLink%20USB%20Graphics%20Software%20for%20Ubuntu6.0-EXE.zip
}
