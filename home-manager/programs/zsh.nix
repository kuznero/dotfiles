{ config, pkgs, lib, ... }:

let
  shellAliases = {
    fv = ''fzf --bind "enter:execute(nvim {})"'';
    gci = "git commit";
    gco = "git checkout";
    gl = "git pull --all --prune";
    gp = "git push";
    gst = "git status";
    lzd = "lazydocker";
    lzg = "lazygit";
    n = "nvim";
    v = "nvim";
    tma = "tmux attach -t ";
    tml = "tmux ls";
    tmk = "tmux kill-server";
  };
in {
  programs.zsh = {
    inherit shellAliases;
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    history = {
      extended = true;
      share = true;
      ignoreDups = false;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "fzf" "git" "git-extras" "kube-ps1" "man" "systemd" "tmux" ];
      # ref: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
      theme = "af-magic";
    };

    initExtraBeforeCompInit = ''
      command -v brew >/dev/null 2>&1 && {
        FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
      }
    '';

    initExtra = ''
      if [ -e ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh;
      fi

      ${lib.fileContents ./dotfiles/.zshrc}
    '';
  };
}
