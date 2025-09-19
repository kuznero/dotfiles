{ config, lib, pkgs, system, user, userName, ... }:

{
  # ref: https://nix.catppuccin.com/search/rolling/?scope=home-manager%20modules
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  home.username = user;
  home.homeDirectory = lib.mkForce
    (if builtins.match ".*-darwin" system != null then
      "/Users/${user}"
    else if builtins.match ".*-linux" system != null then
      "/home/${user}"
    else
      "/home/${user}");

  home.enableNixpkgsReleaseCheck = false;

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/${config.home.username}/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
