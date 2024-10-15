{ config, lib, pkgs, ... }:

let
  os = builtins.currentSystem;

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

  # nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs-unstable
  # nix-channel --update
  unstable = import <nixpkgs-unstable> {
    config = {
      allowUnfree = true;
    };
  };

in
{
  nixpkgs.config.allowUnfree = true;

  home.username = builtins.getEnv "USER";
  home.homeDirectory =
    if builtins.match ".*-darwin" os != null then
      "/Users/${config.home.username}"
    else if builtins.match ".*-linux" os != null then
      "/home/${config.home.username}"
    else
      "/home/${config.home.username}";

  home.stateVersion = "24.05"; # Please read the comment before changing.
  home.enableNixpkgsReleaseCheck = false;

  programs.vscode = {
    enable = true;
    package = unstable.vscode;
  };

  home.activation.afterWriteBoundary =
    let
      # $HOME/.config/Code (on Linux)
      # $HOME/Library/Application Support/Code (on macOS)
      vscodeDir =
        if builtins.match ".*-darwin" os != null then
          "${config.home.homeDirectory}/Library/Application Support/Code/User"
        else if builtins.match ".*-linux" os != null then
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

        # echo [info] uninstalling VSCode existing extensions
        # ${pkgs.vscode}/bin/code --list-extensions | xargs -I {} ${pkgs.vscode}/bin/code --uninstall-extension {} --force
        # echo

        echo [info] installing VSCode  extensions
        cat ${pkgs.writeText "tmp_vscode_extensions" (builtins.readFile ./dotfiles/vscode/extensions.txt)} | xargs -I {} ${pkgs.vscode}/bin/code --install-extension {} --force
        echo

        echo [info] deploy Kitty settings
        mkdir -p "${kittyDir}" >/dev/null 2>&1
        rm -f "${vscodeDir}/kitty.conf" >/dev/null 2>&1
        cat ${pkgs.writeText "tmp_kitty_settings" (builtins.readFile ./dotfiles/kitty/kitty.conf)} > "${kittyDir}/kitty.conf"
        echo
      '';
  };

  home.packages = with pkgs; [
    btop
    flux
    k9s
    kdiff3
    kitty
    kubectl
    lazydocker
    lazygit
    monaspace
    neofetch
    obsidian
    sublime-merge
    telegram-desktop
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
    enable = true;
    package = pkgs.chromium;
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "bhchdcejhohfmigjafbampogmaanbfkg" # User-Agent Switcher and Manager
    ];
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;

    extraPackages = with pkgs; [
      # LazyVim
      lua-language-server
      stylua
      # Telescope
      ripgrep
    ];

    plugins = with pkgs.vimPlugins; [
      lazy-nvim
    ];

    extraLuaConfig =
      let
        plugins = with pkgs.vimPlugins; [
          # LazyVim
          LazyVim
          bufferline-nvim
          cmp-buffer
          cmp-nvim-lsp
          cmp-path
          cmp_luasnip
          conform-nvim
          dashboard-nvim
          dressing-nvim
          flash-nvim
          friendly-snippets
          gitsigns-nvim
          indent-blankline-nvim
          lualine-nvim
          neo-tree-nvim
          neoconf-nvim
          neodev-nvim
          noice-nvim
          nui-nvim
          nvim-cmp
          nvim-lint
          nvim-lspconfig
          nvim-notify
          nvim-spectre
          nvim-treesitter
          nvim-treesitter-context
          nvim-treesitter-textobjects
          nvim-ts-autotag
          nvim-ts-context-commentstring
          nvim-web-devicons
          persistence-nvim
          plenary-nvim
          telescope-fzf-native-nvim
          telescope-nvim
          todo-comments-nvim
          tokyonight-nvim
          trouble-nvim
          vim-illuminate
          vim-startuptime
          which-key-nvim
          { name = "LuaSnip"; path = luasnip; }
          { name = "catppuccin"; path = catppuccin-nvim; }
          { name = "mini.ai"; path = mini-nvim; }
          { name = "mini.bufremove"; path = mini-nvim; }
          { name = "mini.comment"; path = mini-nvim; }
          { name = "mini.indentscope"; path = mini-nvim; }
          { name = "mini.pairs"; path = mini-nvim; }
          { name = "mini.surround"; path = mini-nvim; }
        ];
        mkEntryFromDrv = drv:
          if lib.isDerivation drv then
            { name = "${lib.getName drv}"; path = drv; }
          else
            drv;
        lazyPath = pkgs.linkFarm "lazy-plugins" (builtins.map mkEntryFromDrv plugins);
      in
      ''
        require("lazy").setup({
          defaults = {
            lazy = true,
          },
          dev = {
            -- reuse files from pkgs.vimPlugins.*
            path = "${lazyPath}",
            patterns = { "." },
            -- fallback to download
            fallback = true,
          },
          spec = {
            { "LazyVim/LazyVim", import = "lazyvim.plugins" },
            -- The following configs are needed for fixing lazyvim on nix
            -- force enable telescope-fzf-native.nvim
            { "nvim-telescope/telescope-fzf-native.nvim", enabled = true },
            -- disable mason.nvim, use programs.neovim.extraPackages
            { "williamboman/mason-lspconfig.nvim", enabled = false },
            { "williamboman/mason.nvim", enabled = false },
            -- import/override with your plugins
            { import = "plugins" },
            -- -- treesitter handled by xdg.configFile."nvim/parser", put this line at the end of spec to clear ensure_installed
            {
              "nvim-treesitter/nvim-treesitter",
              opts = function(_, opts)
                opts.ensure_installed = {}
              end,
            },
          },
        })
      '';
  };

  # https://github.com/nvim-treesitter/nvim-treesitter#i-get-query-error-invalid-node-type-at-position
  xdg.configFile."nvim/parser".source =
    let
      parsers = pkgs.symlinkJoin {
        name = "treesitter-parsers";
        paths = (pkgs.vimPlugins.nvim-treesitter.withPlugins (plugins: with plugins; [
          c
          lua
        ])).dependencies;
      };
    in
    "${parsers}/parser";

  # Normal LazyVim config here, see https://github.com/LazyVim/starter/tree/main/lua
  xdg.configFile."nvim/lua".source = ./dotfiles/LazyVim/lua;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
