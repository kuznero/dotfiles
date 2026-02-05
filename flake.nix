{
  description = "Roku Labs NixOS and Home-Manager flake";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-stable = { url = "github:NixOS/nixpkgs?ref=nixos-25.11"; };
    # ref: https://github.com/NixOS/nixos-hardware/tree/master
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = { url = "github:nix-community/home-manager/release-25.11"; };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    catppuccin.url = "github:catppuccin/nix";
    ghostty = { url = "github:ghostty-org/ghostty"; };
    # Pinned nixpkgs for zed-editor (binary cached version)
    nixpkgs-zed.url =
      "github:NixOS/nixpkgs/1327e798cb055f96f92685df444e9a2c326ab5ed";
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager
    , nixvim, nixos-wsl, catppuccin, ghostty, nixpkgs-zed }@inputs:
    let
      user = "roku";
      userName = "Roman Kuznetsov";

      # Overlay to fix setproctitle test failures in sandboxed builds
      setproctitleOverlay = final: prev: {
        python3 = prev.python3.override {
          packageOverrides = pyFinal: pyPrev: {
            setproctitle =
              pyPrev.setproctitle.overrideAttrs (old: { doCheck = false; });
          };
        };
        python3Packages = final.python3.pkgs;
      };
    in {

      formatter.x86_64-linux = let
        pkgs-unstable = import nixpkgs {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
      in pkgs-unstable.nixfmt-classic;

      nixosConfigurations = {
        moon = # sudo nixos-rebuild switch --flake .#moon --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user userName; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "25.11";
              }

              catppuccin.nixosModules.catppuccin

              # ref: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
              nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen

              # basic configuration & users
              ./nixos/moon/configuration.nix
              ./nixos/user.nix

              # desktop
              # ./nixos/gnome.nix
              ./nixos/kde-plasma.nix

              # features
              ./nixos/displaylink.nix
              ./nixos/docker.nix
              ./nixos/flatpak.nix
              ./nixos/fonts.nix
              # ./nixos/gaming.nix
              ./nixos/logind.nix
              ./nixos/media.nix
              ./nixos/ollama.nix
              # ./nixos/podman.nix
              ./nixos/vpn.nix

              # packages
              ./nixos/1password.nix
            ];
          };

        sun = # sudo nixos-rebuild switch --flake .#sun --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user userName; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "25.11";
              }

              # basic configuration & users
              ./nixos/sun/configuration.nix
              ./nixos/user.nix

              # features
              ./nixos/docker.nix
              ./nixos/logind.nix
              ./nixos/github-runner.nix
              # ./nixos/ollama.nix
              ./nixos/onlyoffice-server.nix
              ./nixos/athens.nix
            ];
          };

        wsl = # sudo nixos-rebuild switch --flake .#wsl --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user userName; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "25.11";
              }

              catppuccin.nixosModules.catppuccin

              # basic configuration & users
              ./nixos/wsl/configuration.nix
              ./nixos/user.nix

              # features
              ./nixos/docker.nix
              ./nixos/flatpak.nix
              ./nixos/gnupg.nix
              # ./nixos/podman.nix
            ];
          };
      };

      homeConfigurations = {
        moon = # home-manager switch --flake .#moon
          let
            system = "x86_64-linux";
            pkgs-stable = import inputs.nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
            pkgs-zed = import nixpkgs-zed {
              system = system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit inputs system user userName pkgs-stable pkgs-zed;
            };
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              catppuccin.homeModules.catppuccin

              ./home/user.nix
              ./home/bcompare.nix
              ./home/browsers.nix
              ./home/common.nix
              ./home/dotfiles.nix
              ./home/filezilla.nix
              ./home/fzf.nix
              ./home/games.nix
              (import ./home/ghostty.nix {
                inputs = inputs;
                pkgs = nixpkgs.legacyPackages.${system};
                system = system;
                theme = "dark:catppuccin-mocha,light:catppuccin-latte";
                fontFamily = "Hurmit Nerd Font";
                fontSize = "14";
                adjustCellHeight = "0%";
              })
              ./home/git.nix
              # ./home/jetbrains.nix
              ./home/messengers.nix
              (import ./home/nixvim/default.nix {
                inputs = inputs;
                pkgs = nixpkgs.legacyPackages.${system};
                system = system;
              })
              ./home/obsidian.nix
              ./home/office.nix
              ./home/pcloud.nix
              ./home/rustdesk.nix
              ./home/scripts.nix
              ./home/spotify.nix
              ./home/tmux.nix
              ./home/transmission.nix
              ./home/zed-editor.nix
              ./home/zoxide.nix
              ./home/zsh.nix
            ];
          };

        mac = # home-manager switch --flake .#mac
          let
            system = "aarch64-darwin";
            pkgs = import nixpkgs {
              system = system;
              config.allowUnfree = true;
              overlays = [ setproctitleOverlay ];
            };
            pkgs-stable = import nixpkgs-stable {
              system = system;
              config.allowUnfree = true;
              overlays = [ setproctitleOverlay ];
            };
            pkgs-zed = import nixpkgs-zed {
              system = system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit inputs system user userName pkgs-stable pkgs-zed;
            };
            pkgs = pkgs;
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              catppuccin.homeModules.catppuccin

              ./home/user.nix
              ./home/common.nix
              ./home/dotfiles.nix
              ./home/fzf.nix
              (import ./home/ghostty.nix {
                inputs = inputs;
                pkgs = nixpkgs.legacyPackages.${system};
                system = system;
                theme = "dark:catppuccin-mocha,light:catppuccin-latte";
                fontFamily = "Hurmit Nerd Font";
                fontSize = "20";
                # adjustCellHeight = "0%";
                adjustCellWidth = "-10%";
              })
              ./home/git.nix
              (import ./home/nixvim/default.nix {
                inputs = inputs;
                pkgs = nixpkgs.legacyPackages.${system};
                system = system;
              })
              # ./home/ollama.nix
              ./home/scripts.nix
              ./home/tmux.nix
              ./home/yabai.nix
              ./home/zed-editor.nix
              ./home/zoxide.nix
              ./home/zsh.nix
            ];
          };

        wsl = # home-manager switch --flake .#wsl
          let
            system = "x86_64-linux";
            pkgs-stable = import inputs.nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit inputs system user userName pkgs-stable;
            };
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              catppuccin.homeModules.catppuccin

              ./home/user.nix
              ./home/bcompare.nix
              ./home/common.nix
              ./home/dotfiles.nix
              ./home/fzf.nix
              ./home/git.nix
              (import ./home/nixvim/default.nix {
                inputs = inputs;
                pkgs = nixpkgs.legacyPackages.${system};
                system = system;
              })
              ./home/obsidian.nix
              ./home/scripts.nix
              ./home/tmux.nix
              ./home/zoxide.nix
              ./home/zsh.nix
            ];
          };
      };

      # devShells = {
      #
      #   default = pkgs-unstable.mkShell {
      #     hardeningDisable = [ "fortify" ];
      #     buildInputs = dev-inputs;
      #     shellHook = ''
      #       temp_dir=$(mktemp -d)
      #       cp $HOME/.zshenv $temp_dir/.zshenv || touch $temp_dir/.zshenv
      #       cp $HOME/.zshrc $temp_dir/.zshrc || touch $temp_dir/.zshrc
      #       chmod 0644 $temp_dir/.zshenv $temp_dir/.zshrc
      #
      #       export NIX_FLAKE_NAME="Nix DevEnv"
      #       export PATH="$(pwd)/scripts:$PATH"
      #
      #       cat <<EOF >> $temp_dir/.zshrc
      #       export NIX_FLAKE_NAME="Nix DevEnv"
      #       export PATH="${toString self}/scripts:$PATH"
      #       alias dev="echo dev"
      #       # extend with custom aliases/functions/etc.
      #       EOF
      #
      #       ZDOTDIR=$temp_dir exec ${pkgs-unstable.zsh}/bin/zsh
      #     '';
      #   };
      #
      #   ci = pkgs-unstable.mkShell {
      #     hardeningDisable = [ "fortify" ];
      #     buildInputs = dev-inputs;
      #   };
      #
      # };
    };
}
