{ config, pkgs, ... }:

let
  shellAliases = {
    gst = "git status";
    gl = "git pull --all --prune";
    gp = "git push";
    gci = "git commit";
    gco = "git checkout";
    fv = "fzf --bind \"enter:execute(nvim {})\"";
    v = "nvim";
    n = "nvim";
    lzg = "lazygit";
    lzd = "lazydocker";
  };
in
{
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
      plugins = [
        "docker"
        "fzf"
        "git"
        "git-extras"
        "man"
        "systemd"
        "tmux"
      ];
      # ref: https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
      theme = "af-magic";
    };

    initExtraBeforeCompInit = ''
      command -v brew >/dev/null 2>&1 && {
        FPATH="$(brew --prefix)/share/zsh/site-functions:$FPATH"
      }
    '';

    initExtra = ''
      EDITOR=nvim

      if [ -e ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then
        source ${config.home.homeDirectory}/.nix-profile/etc/profile.d/nix.sh;
      fi

      if [[ -f "/opt/homebrew/bin/brew" ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
      fi

      if [[ "$TERM_PROGRAM" = vscode ]]; then
        export EDITOR=code;
        alias vim=code;
        alias v=code;
      fi

      command -v k9s >/dev/null 2>&1 && {
        alias k9='k9s --request-timeout=10s --headless --command namespaces'
      }

      command -v kubectl >/dev/null 2>&1 && {
        alias k='kubectl'
        # shellcheck disable=SC1090
        source <(kubectl completion zsh)
        # complete -F __start_kubectl k
      }

      command -v helm >/dev/null 2>&1 && {
        alias h='helm'
        # shellcheck disable=SC1090
        source <(helm completion zsh)
        # complete -F __start_helm h
      }

      command -v flux >/dev/null 2>&1 && {
        alias f='flux'
        # shellcheck disable=SC1090
        source <(flux completion zsh)
        # complete -F __start_flux f
      }

      command -v fzf >/dev/null 2>&1 && {
        source <(fzf --zsh)
      }

      command -v talosctl >/dev/null 2>&1 && {
        source <(talosctl completion zsh)
      }

      if [ -n "$NIX_FLAKE_NAME" ]; then
        export RPROMPT="%F{green}($NIX_FLAKE_NAME)%f";
      fi
    '';
  };
}
