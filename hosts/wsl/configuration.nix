{ pkgs, system, user, ... }:

{
  imports = [ <nixos-wsl/modules> ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.hostPlatform = system;

  programs.nix-ld.enable = true;

  wsl.enable = true;
  wsl.defaultUser = user;

  users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "Roman Kuznetsov";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  security.pki.certificateFiles = [ /etc/pki/tls/certs/ca-zscaler.crt ];
  environment.variables = {
    "NIX_SSL_CERT_FILE" = "/etc/ssl/certs/ca-certificates.crt";
  };

  security.sudo.extraConfig = ''Defaults env_keep += "NIX_SSL_CERT_FILE"'';

  environment.systemPackages = with pkgs; [ gitFull vim ];
}
