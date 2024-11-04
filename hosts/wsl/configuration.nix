{ pkgs, system, user, ... }:

{
  imports = [ <nixos-wsl/modules> ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.hostPlatform = system;

  wsl.enable = true;
  wsl.defaultUser = user;

  # This setting should be enough, but seems to be ignored.
  security.pki.certificateFiles = [
    /etc/pki/tls/certs/ca-zscaler.crt
  ];

  # This sets the env var for all shells
  environment.variables = {
    "NIX_SSL_CERT_FILE" = "/etc/pki/tls/certs/ca-zscaler.crt";
  };

  # This adds an extra line to sudoers to always keep this variable
  security.sudo.extraConfig = ''
    Defaults env_keep += "NIX_SSL_CERT_FILE"
  '';  

  environment.systemPackages = with pkgs; [
    gitFull
    vim
  ];
}
