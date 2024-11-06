{
  description = "Roku Labs NixOS and Home-Manager flake";

  inputs = {

    nixpkgs = { url = "github:NixOS/nixpkgs?ref=nixos-24.05"; };

    nixpkgs-unstable = { url = "github:NixOS/nixpkgs?ref=master"; };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs =
    { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, nixos-wsl }@inputs:
    let user = "roku";
    in {

      nixosConfigurations = {
        moon = # sudo nixos-rebuild switch --flake .#moon --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "24.05";
              }

              # basic configuration & users
              ./hosts/moon/configuration.nix
              ./users/${user}.nix

              # features
              ./hosts/displaylink.nix
              ./hosts/docker.nix
              ./hosts/flatpak.nix
              ./hosts/fonts.nix
              ./hosts/gnome.nix
              ./hosts/hyprland.nix
              ./hosts/logind.nix
              ./hosts/ollama.nix

              # packages
              ./pkgs/1password.nix
            ];
          };

        devos = # sudo nixos-rebuild switch --flake .#devos --impure
          let system = "aarch64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user nixos-wsl; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "24.05";
              }

              # basic configuration & users
              ./hosts/devos/configuration.nix
              ./users/${user}.nix

              # features
              ./hosts/docker.nix
              ./hosts/flatpak.nix
              ./hosts/fonts.nix
              ./hosts/gnome.nix
              ./hosts/hyprland.nix
              ./hosts/logind.nix
              ./hosts/ollama.nix

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
                system.stateVersion = "24.05";
              }

              # basic configuration & users
              ./hosts/sun/configuration.nix
              ./users/${user}.nix

              # features
              ./hosts/docker.nix
              ./hosts/logind.nix
              ./hosts/gitlab-runner.nix

              # packages
              ./pkgs/1password.nix
            ];
          };

        wsl = # sudo nixos-rebuild switch --flake .#wsl --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs system user; };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                system.stateVersion = "24.05";
              }

              # basic configuration & users
              ./hosts/wsl/configuration.nix
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

              ./home-manager/${user}.nix

              ./home-manager/programs/bcompare.nix
              ./home-manager/programs/chromium.nix
              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              ./home-manager/programs/git.nix
              ./home-manager/programs/nixvim.nix
              ./home-manager/programs/ollama.nix
              ./home-manager/programs/pcloud.nix
              ./home-manager/programs/telegram.nix
              ./home-manager/programs/transmission.nix
              ./home-manager/programs/vscode.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
              (import ./home-manager/programs/wezterm.nix {
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                fontFamily = "Iosevka Nerd Font";
                fontWeight = "ExtraLight";
                fontSize = 12.0;
                lineHeight = 1.0;
              })
            ];
          };

        devos = # home-manager switch --flake .#devos
          let
            system = "aarch64-linux";
            pkgs-stable = import inputs.nixpkgs {
              system = system;
              config.allowUnfree = true;
            };
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = { inherit inputs system user pkgs-stable; };
            pkgs = nixpkgs-unstable.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              ./home-manager/${user}.nix

              ./home-manager/programs/chromium.nix
              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              ./home-manager/programs/git.nix
              ./home-manager/programs/nixvim.nix
              ./home-manager/programs/ollama.nix
              ./home-manager/programs/telegram.nix
              ./home-manager/programs/transmission.nix
              ./home-manager/programs/vscode.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
              (import ./home-manager/programs/wezterm.nix {
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                fontFamily = "Iosevka Nerd Font";
                fontWeight = "ExtraLight";
                fontSize = 12.0;
                lineHeight = 1.0;
              })
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

              ./home-manager/${user}.nix

              # ./home-manager/programs/bcompare.nix
              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              ./home-manager/programs/git.nix
              ./home-manager/programs/nixvim.nix
              ./home-manager/programs/ollama.nix
              ./home-manager/programs/vscode.nix
              ./home-manager/programs/yabai.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
              (import ./home-manager/programs/wezterm.nix {
                pkgs = nixpkgs-unstable.legacyPackages.${system};
                fontFamily = "Mononoki Nerd Font";
                fontWeight = "Regular";
                fontSize = 16.0;
                lineHeight = 1.1;
              })
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

              ./home-manager/${user}.nix

              ./home-manager/programs/common.nix
              ./home-manager/programs/fzf.nix
              ./home-manager/programs/git.nix
              ./home-manager/programs/nixvim.nix
              ./home-manager/programs/zoxide.nix
              ./home-manager/programs/zsh.nix
            ];
          };

      };

    };
}
