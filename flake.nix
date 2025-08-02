{
  description = "Roku Labs NixOS and Home-Manager flake";

  inputs = {

    nixpkgs = { url = "github:NixOS/nixpkgs?ref=nixos-25.05"; };

    nixpkgs-unstable = { url = "github:nixos/nixpkgs/nixos-unstable"; };

    # ref: https://github.com/NixOS/nixos-hardware/tree/master
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    catppuccin.url = "github:catppuccin/nix";

    ghostty = { url = "github:ghostty-org/ghostty"; };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, nixos-hardware, home-manager
    , nixvim, nixos-wsl, catppuccin, ghostty }@inputs:
    let user = "roku";
    in {

      formatter.x86_64-linux = let
        pkgs-unstable = import nixpkgs-unstable {
          system = "x86_64-linux";
          config = { allowUnfree = true; };
        };
      in pkgs-unstable.nixfmt-classic;

      nixosConfigurations = {
        moon = # sudo nixos-rebuild switch --flake .#moon --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "25.05";
              }

              catppuccin.nixosModules.catppuccin

              # ref: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
              nixos-hardware.nixosModules.lenovo-thinkpad-x1-10th-gen

              # basic configuration & users
              ./hosts/moon/configuration.nix
              ./users/${user}.nix

              # desktop
              ./hosts/gnome.nix
              # ./hosts/xfce.nix
              # {
              #   services.xserver.resolutions = [{
              #     x = 1680;
              #     y = 1050;
              #   }];
              # }

              # features
              ./hosts/displaylink.nix
              ./hosts/docker.nix
              ./hosts/flatpak.nix
              ./hosts/fonts.nix
              ./hosts/gaming.nix
              ./hosts/logind.nix
              ./hosts/media.nix
              ./hosts/ollama.nix
              ./hosts/vpn.nix

              # packages
              ./pkgs/1password.nix
            ];
          };

        sun = # sudo nixos-rebuild switch --flake .#sun --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "25.05";
              }

              # basic configuration & users
              ./hosts/sun/configuration.nix
              ./users/${user}.nix

              # features
              ./hosts/docker.nix
              ./hosts/logind.nix
              ./hosts/github-runner.nix
              ./hosts/onlyoffice-server.nix
            ];
          };

        wsl = # sudo nixos-rebuild switch --flake .#wsl --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "25.05";
              }

              catppuccin.nixosModules.catppuccin

              # basic configuration & users
              ./hosts/wsl/configuration.nix

              # features
              ./hosts/docker.nix
              ./hosts/flatpak.nix
              ./hosts/gnupg.nix
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
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs system user pkgs-stable; };
            pkgs = nixpkgs-unstable.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              catppuccin.homeModules.catppuccin

              ./home-manager/${user}.nix

              ./home-manager/programs/bcompare.nix
              ./home-manager/programs/browsers.nix
              ./home-manager/programs/common.nix
              ./home-manager/programs/cursor.nix
              ./home-manager/programs/dotfiles.nix
              ./home-manager/programs/filezilla.nix
              ./home-manager/programs/fzf.nix
              (import ./home-manager/programs/ghostty.nix {
                inputs = inputs;
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                system = system;
                theme = "catppuccin-mocha";
                fontFamily = "Mononoki Nerd Font";
                fontSize = "14";
                adjustCellHeight = "0%";
              })
              ./home-manager/programs/git.nix
              # ./home-manager/programs/jetbrains.nix
              ./home-manager/programs/messengers.nix
              ./home-manager/programs/mkdocs.nix
              (import ./home-manager/programs/nixvim.nix {
                inputs = inputs;
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                system = system;
                ollamaModel = "qwen2.5-coder:1.5b";
              })
              ./home-manager/programs/obsidian.nix
              ./home-manager/programs/office.nix
              ./home-manager/programs/pcloud.nix
              ./home-manager/programs/scripts.nix
              ./home-manager/programs/spotify.nix
              ./home-manager/programs/tmux.nix
              ./home-manager/programs/transmission.nix
              # ./home-manager/programs/xfce.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
            ];
          };

        mac = # home-manager switch --flake .#mac
          let
            system = "aarch64-darwin";
            pkgs-stable = import inputs.nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs system user pkgs-stable; };
            pkgs = nixpkgs-unstable.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              catppuccin.homeModules.catppuccin

              ./home-manager/${user}.nix

              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              (import ./home-manager/programs/ghostty.nix {
                inputs = inputs;
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                system = system;
                # theme = "dark:catppuccin-mocha,light:catppuccin-latte";
                theme = "catppuccin-mocha";
                fontFamily = "0xProto Nerd Font";
                fontSize = "18";
                adjustCellHeight = "0%";
              })
              ./home-manager/programs/git.nix
              ./home-manager/programs/mkdocs.nix
              (import ./home-manager/programs/nixvim.nix {
                inputs = inputs;
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                system = system;
                ollamaModel = "qwen2.5-coder:7b";
              })
              ./home-manager/programs/ollama.nix
              ./home-manager/programs/scripts.nix
              ./home-manager/programs/tmux.nix
              ./home-manager/programs/yabai.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
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
            extraSpecialArgs = { inherit inputs system user pkgs-stable; };
            pkgs = nixpkgs-unstable.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              catppuccin.homeModules.catppuccin

              ./home-manager/${user}.nix

              ./home-manager/programs/bcompare.nix
              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              ./home-manager/programs/git.nix
              ./home-manager/programs/mkdocs.nix
              (import ./home-manager/programs/nixvim.nix {
                inputs = inputs;
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                system = system;
                ollamaModel = "qwen2.5-coder:1.5b";
              })
              ./home-manager/programs/obsidian.nix
              ./home-manager/programs/scripts.nix
              ./home-manager/programs/tmux.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
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
