{ pkgs, ... }:

{
  imports = [ /etc/nixos/hardware-configuration.nix ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.nix-ld.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ref: https://github.com/NixOS/nixpkgs/issues/448088
  boot.kernelParams = [ "mt7921_common.disable_clc=1" ];

  # Graphical boot splash - hides tiny 4K console text
  boot.initrd.systemd.enable = true;
  boot.plymouth = {
    enable = true;
    theme = "breeze";
  };

  networking.hostName = "moon";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Copenhagen";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  environment.systemPackages = with pkgs; [ blueman vim ];

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services = {
    blueman.enable = true;
    xserver = {
      enable = true;
      xkb.layout = "us,ru";
      xkb.options = "grp:win_space_toggle";
    };
  };

  services.openssh.enable = true;
}
