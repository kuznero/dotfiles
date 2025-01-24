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
    tm = "tmux";
    tma = "tmux attach -t ";
    tml = "tmux ls";
    tmk = "tmux kill-server";
  };
in
{
  home.file = {
    ".config/startship.toml".source = ./dotfiles/.config/starship.toml;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    package = pkgs.starship;
  };

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
