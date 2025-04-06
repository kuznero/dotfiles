{ lib, pkgs, ... }:

{
  networking.wireguard.enable = true;
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  environment.systemPackages = with pkgs; [ mullvad-vpn ];
}
