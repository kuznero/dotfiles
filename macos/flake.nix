{
  description = "Roku system flake for Darwin";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager }:
  let
    configuration = { pkgs, ... }: {
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [ pkgs.vim
        ];

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Create /etc/zshrc that loads the nix-darwin environment.
      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableBashCompletion = true;
      };

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";

      users.users.roku = {
       name = "roku";
       home = "/Users/roku";
      };

      home-manager = {
        useUserPackages = true;
        useGlobalPkgs = true;
      };

      home-manager.users.roku = { pkgs, ...}: {
        home.packages = with pkgs; [
          # # Command Tools
          # coreutils
          # wget
          # curl
	  # git
          # jq
          # nodejs
          # fzf
          # readline
	  # btop
	  # bat
	  # eza
	  # tree
	  # cloc
	  # fontconfig
	  # fd
	  # gnugrep
	  ## ZSH packages
	  zsh
	  oh-my-zsh
	  # #### neovim packages
          # neovim
	  # lunarvim
	  # ####
          # #### Emacs
          # emacs
          # ######
          # lazygit
          # pandoc
          # neofetch
          # ipfetch
          # ripgrep
          # tldr
          # ranger
          # tailwindcss
          # vpsfree-client
          # # Window Manager and Desktop
          # skhd
	  # sketchybar
	  # ######
          # kitty
	  # ###
	  # cocoapods
          # # C
          # mpi
          # cmake
          # zeromq
          # # JDK and JVM based
          # jdk21
          # clojure
          # polylith
          # babashka
          # bbin
          # # Rust
          # rustc
          # cargo
          # rustfmt
          # clippy
          # # Lua
          # (lua.withPackages(ps: with ps; [
          #     busted
          #     luafilesystem
          #     readline
          #     fennel
          #   ]))
          # # Python
          # python3
          # # Ops
          # docker_27
          # # terraform
          # #kubernetes
          # #ngrok
          # # DB
          # sqlite
          # postgresql
          # #wezterm
        ];

        home.stateVersion = "24.11";
      };
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#Romans-MacBook-Pro
    darwinConfigurations."Romans-MacBook-Pro" = nix-darwin.lib.darwinSystem {
      modules = [ home-manager.darwinModules.home-manager configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."Romans-MacBook-Pro".pkgs;
  };
}
