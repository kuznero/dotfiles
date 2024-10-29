{ config, lib, pkgs, system, user, ... }:

{
  home.username = user;
  home.homeDirectory = lib.mkForce (
    if builtins.match ".*-darwin" system != null then
      "/Users/${config.home.username}"
    else if builtins.match ".*-linux" system != null then
      "/home/${config.home.username}"
    else
      "/home/${config.home.username}"
  );

  home.enableNixpkgsReleaseCheck = false;

  home.activation.afterWriteBoundary =
    let
      # $HOME/.config/Code (on Linux)
      # $HOME/Library/Application Support/Code (on macOS)
      vscodeDir =
        if builtins.match ".*-darwin" system != null then
          "${config.home.homeDirectory}/Library/Application Support/Code/User"
        else if builtins.match ".*-linux" system != null then
          "${config.home.homeDirectory}/.config/Code/User"
        else
          "${config.home.homeDirectory}/.config/Code/User";

      kittyDir = "${config.home.homeDirectory}/.config/kitty";

      # Hyprland components
      hyprDir = "${config.home.homeDirectory}/.config/hypr";
      waybarDir = "${config.home.homeDirectory}/.config/waybar";
      dunstDir = "${config.home.homeDirectory}/.config/dunst";
      fishDir = "${config.home.homeDirectory}/.config/fish";
    in
    {
      after = [ "writeBoundary" ];
      before = [];
      data = ''
        #!${pkgs.stdenv.shell}
        ${pkgs.rsync}/bin/rsync --mkpath -avvh --delete --perms --chmod=u=rwX ${toString ../dotfiles/vscode}/ "${vscodeDir}/"
        ${pkgs.rsync}/bin/rsync --mkpath -avvh --delete --perms --chmod=u=rwX ${toString ../dotfiles/kitty}/ "${kittyDir}/"
        ${pkgs.rsync}/bin/rsync --mkpath -avvh --delete --perms --chmod=u=rwX ${toString ../dotfiles/hypr}/ "${hyprDir}/"
        ${pkgs.rsync}/bin/rsync --mkpath -avvh --delete --perms --chmod=u=rwX ${toString ../dotfiles/waybar}/ "${waybarDir}/"
        ${pkgs.rsync}/bin/rsync --mkpath -avvh --delete --perms --chmod=u=rwX ${toString ../dotfiles/dunst}/ "${dunstDir}/"
        ${pkgs.rsync}/bin/rsync --mkpath -avvh --delete --perms --chmod=u=rwX ${toString ../dotfiles/fish}/ "${fishDir}/"
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

  home.stateVersion = "24.05";

  # Do not let home manager install and manage itself
  programs.home-manager.enable = false;
}

