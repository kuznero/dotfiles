{ pkgs, user, ... }:

{
  programs.zsh.enable = true;

  users.users.${user} = {
    isNormalUser = true;
    description = "RoKu";
    extraGroups = [ "docker" "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };
}
