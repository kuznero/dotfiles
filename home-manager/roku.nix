{ config, lib, pkgs, system, user, ... }:

{
  # ref: https://nix.catppuccin.com/search/rolling/?scope=home-manager%20modules
  catppuccin.enable = true;
  catppuccin.flavor = "mocha";

  home.username = user;
  home.homeDirectory = lib.mkForce
    (if builtins.match ".*-darwin" system != null then
      "/Users/${config.home.username}"
    else if builtins.match ".*-linux" system != null then
      "/home/${config.home.username}"
    else
      "/home/${config.home.username}");

  home.enableNixpkgsReleaseCheck = false;

  home.activation.afterWriteBoundary = let
    # $HOME/.config/Code (on Linux)
    # $HOME/Library/Application Support/Code (on macOS)
    vscodeDir = if builtins.match ".*-darwin" system != null then
      "${config.home.homeDirectory}/Library/Application Support/Code/User"
    else if builtins.match ".*-linux" system != null then
      "${config.home.homeDirectory}/.config/Code/User"
    else
      "${config.home.homeDirectory}/.config/Code/User";
  in {
    after = [ "writeBoundary" ];
    before = [ ];
    data = ''
      #!${pkgs.stdenv.shell}
      ${pkgs.rsync}/bin/rsync --mkpath -avvh --delete --perms --chmod=u=rwX ${
        toString ../dotfiles/vscode
      }/ "${vscodeDir}/"
    '';
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

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
