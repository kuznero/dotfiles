{ pkgs, system, user, ... }:

{
  imports = [ <nixos-wsl/modules> ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nixpkgs.hostPlatform = system;

  programs.nix-ld.enable = true;

  wsl = {
    enable = true;
    defaultUser = user;
    wslConf.interop.enabled = true;
    wslConf.interop.appendWindowsPath = true;
  };

  # Fix WSL interop for Windows executables like VS Code
  # This is a workaround for a known issue where NixOS's systemd-binfmt service removes
  # the WSLInterop registration, breaking Windows binary execution (including VS Code).
  #
  # Related issues:
  # - https://github.com/nix-community/NixOS-WSL/issues/552 - systemd-binfmt conflicts
  # - https://github.com/nix-community/NixOS-WSL/issues/196 - boot.binfmt.emulatedSystems doesn't work
  # - https://github.com/nix-community/NixOS-WSL/pull/64 - PR with binfmt/interop fixes
  # - https://github.com/nix-community/NixOS-WSL/issues/238 - VSCode connection issues
  # - https://github.com/nix-community/NixOS-WSL/issues/294 - VSCode setup documentation
  #
  # The proper solution would be to use: wsl.interop.register = true;
  # However, this defaults to false due to global binfmt_misc state affecting all WSL distros.
  # See: https://github.com/nix-community/NixOS-WSL/blob/main/modules/interop.nix
  systemd.services.fix-wsl-interop = {
    description = "Fix WSL Interop for Windows executables";
    after = [ "systemd-binfmt.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = "${pkgs.bash}/bin/bash -c 'echo :WSLInterop:M::MZ::/init:PF > /proc/sys/fs/binfmt_misc/register || true'";
    };
  };

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

  environment.systemPackages = with pkgs; [
    vim
    wslu  # WSL utilities including wslview for better Windows integration
  ];
}
