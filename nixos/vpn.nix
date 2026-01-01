{ lib, pkgs, ... }:

{
  programs.openvpn3.enable = true;
  networking.networkmanager.plugins = [ pkgs.networkmanager-openvpn ];
  networking.wireguard.enable = true;
  services.mullvad-vpn = {
    enable = true;
    package = pkgs.mullvad-vpn;
  };

  environment.systemPackages = with pkgs; [ mullvad-vpn ];
}
