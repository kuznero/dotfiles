{ config, pkgs, inputs, system, user, ... }:

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
  # nix = {
  #   package = pkgs.nix;
  #   settings.experimental-features = [ "nix-command" "flakes" ];
  # };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim
  ];

  home.username = user;
  home.homeDirectory =
    if builtins.match ".*-darwin" system != null then
      "/Users/${config.home.username}"
    else if builtins.match ".*-linux" system != null then
      "/home/${config.home.username}"
    else
      "/home/${config.home.username}";

  home.enableNixpkgsReleaseCheck = false;

  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
  };

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

        # echo [info] deploy VSCode settings and keybindings
        # mkdir -p "${vscodeDir}" >/dev/null 2>&1
        # rm -f "${vscodeDir}/settings.json*" "${vscodeDir}/keybindings.json*" >/dev/null 2>&1
        # cat ${pkgs.writeText "tmp_vscode_settings" (builtins.readFile ./dotfiles/vscode/settings.json)} | jq --monochrome-output > "${vscodeDir}/settings.json"
        # cat ${pkgs.writeText "tmp_vscode_keybindings" (builtins.readFile ./dotfiles/vscode/keybindings.json)} | jq --monochrome-output > "${vscodeDir}/keybindings.json"
        # echo

        echo [info] deploy Kitty settings
        mkdir -p "${kittyDir}" >/dev/null 2>&1
        rm -f "${vscodeDir}/kitty.conf" >/dev/null 2>&1
        cat ${pkgs.writeText "tmp_kitty_settings" (builtins.readFile ./dotfiles/kitty/kitty.conf)} > "${kittyDir}/kitty.conf"
        echo
      '';
  };

  home.packages = with pkgs; [
    btop
    fd
    flux
    k9s
    kdiff3
    kitty
    kubectl
    lazydocker
    lazygit
    monaspace
    neofetch
    ripgrep
    tmux
    vim
    xclip
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

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    aliases = {
      st = "status";
      ci = "commit";
      co = "checkout";
      l = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=short --branches";
      br = "branch";
      d = "diff --word-diff=color";
      dt = "difftool";
      dtp = "difftool";
      m = "merge";
      mt = "mergetool";
      cl = "clean -x -d -f --exclude output/ --dry-run";
      cls = "clean -x -d -f --exclude output/";
      pl = "pull --all --prune";
      ps = "push";
    };
    userName = "Roman Kuznetsov";
    userEmail = "${config.home.username}@lix.one";
    extraConfig =
    {
      core = {
        autocrlf = "input";
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = false;
      };
      color = {
        ui = true;
      };
    };
  };

  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
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

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--height 40%" "--border" ];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview 'head {}'" ];
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    tmux.enableShellIntegration = true;
    historyWidgetOptions = [ "--sort" "--exact" ];
  };

  # programs.gpg = { enable = true; };

  programs.chromium = {
    enable = builtins.match ".*-linux" system != null;
    package = pkgs.chromium;
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "bhchdcejhohfmigjafbampogmaanbfkg" # User-Agent Switcher and Manager
    ];
  };

  programs.nixvim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    globals = {
      mapleader = " ";
      maplocalleader = " ";
    };

    editorconfig.enable = true;
    colorschemes.catppuccin.enable = true;

    opts = {
      autoindent = true;
      breakindent = true;
      cursorline = false;
      expandtab = true;
      hlsearch = true;
      ignorecase = true;
      incsearch = true;
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      smartcase = true;
      smartindent = true;
      softtabstop = 2;
      swapfile = false;
      tabstop = 2;
      termguicolors = true;
      undofile = true;
      updatetime = 50; # Faster completion
      wrap = false;
    };

    # ref: https://nix-community.github.io/nixvim/index.html
    plugins = {
      bufferline.enable = true;
      cmp-buffer.enable = true;
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp.enable = true;
      cmp_luasnip.enable = true;
      conform-nvim.enable = true;
      dressing.enable = true;
      flash.enable = true;
      friendly-snippets.enable = true;
      gitsigns.enable = true;
      illuminate.enable = true;
      indent-blankline.enable = true;
      lazy.enable = true;
      lint.enable = true;
      # lsp.servers = {
      #   gopls = {
      #     enable = true;
      #     autostart = true;
      #     # extraOptions.settings = {
      #     #   gopls = {
      #     #     staticcheck = true;
      #     #     directoryFilters = [
      #     #       "-.git"
      #     #       "-.vscode"
      #     #     ];
      #     #     semanticTokens = true;
      #     #     analyses = {
      #     #       fieldalignment = true;
      #     #       useany = true;
      #     #     };
      #     #   };
      #     # };
      #   };
      #   yamlls.enable = true;
      # };
      lualine.enable = true;
      neo-tree.enable = true;
      nix-develop.enable = true;
      nix.enable = true;
      noice.enable = true;
      notify.enable = true;
      persistence.enable = true;
      spectre.enable = true;
      telescope = {
        enable = true;
        keymaps = {
          "<leader>g" = {
            action = "live_grep";
            options = {
              desc = "Telescope Live Grep";
            };
          };
          "<leader>p" = {
            action = "git_files";
            options = {
              desc = "Telescope Git Files";
            };
          };
          "<leader>b" = {
            action = "buffers";
            options = {
              desc = "Telescope Buffers";
            };
          };
          "<leader>k" = {
            action = "keymaps";
            options = {
              desc = "Telescope Keymaps";
            };
          };
        };
      };
      todo-comments.enable = true;
      treesitter = {
        enable = true;
        grammarPackages = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
          bash
          json
          lua
          make
          markdown
          nix
          regex
          toml
          vim
          vimdoc
          xml
          yaml
        ];
      };
      treesitter-context.enable = true;
      treesitter-textobjects.enable = true;
      trouble.enable = true;
      ts-autotag.enable = true;
      ts-context-commentstring.enable = true;
      web-devicons.enable = true;
      which-key.enable = true;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

