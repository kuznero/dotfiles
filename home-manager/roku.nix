{ config, pkgs, system, user, ... }:

{
  home.username = user;
  home.homeDirectory =
    if builtins.match ".*-darwin" system != null then
      "/Users/${config.home.username}"
    else if builtins.match ".*-linux" system != null then
      "/home/${config.home.username}"
    else
      "/home/${config.home.username}";

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
    in
    {
      after = [ "writeBoundary" ];
      before = [];
      data = ''
        #!${pkgs.stdenv.shell}

        echo [info] deploy VSCode settings and keybindings
        mkdir -p "${vscodeDir}" >/dev/null 2>&1
        rm -f "${vscodeDir}/settings.json*" "${vscodeDir}/keybindings.json*" >/dev/null 2>&1
        cat ${pkgs.writeText "tmp_vscode_settings" (builtins.readFile ./dotfiles/vscode/settings.json)} | jq --monochrome-output > "${vscodeDir}/settings.json"
        cat ${pkgs.writeText "tmp_vscode_keybindings" (builtins.readFile ./dotfiles/vscode/keybindings.json)} | jq --monochrome-output > "${vscodeDir}/keybindings.json"
        echo

        echo [info] deploy Kitty settings
        mkdir -p "${kittyDir}" >/dev/null 2>&1
        rm -f "${kittyDir}/kitty.conf" >/dev/null 2>&1
        cat ${pkgs.writeText "tmp_kitty_settings" (builtins.readFile ./dotfiles/kitty/kitty.conf)} > "${kittyDir}/kitty.conf"
        echo
      '';
  };

  home.packages = with pkgs; [
    bcompare
    flux
    k9s
    kitty
    kubectl
    lazydocker
    lazygit
    zoxide
    zsh

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

