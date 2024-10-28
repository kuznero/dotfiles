{
  description = "Roku Labs NixOS and Home-Manager flake";

  inputs = {

    nixpkgs = {
      url = "github:NixOS/nixpkgs?ref=nixos-24.05";
    };

    nixpkgs-unstable = {
      url = "github:NixOS/nixpkgs?ref=nixpkgs-unstable";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim, nix-darwin }@inputs:
    let
      user = "roku";
    in
    {

      # sudo nixos-rebuild switch --flake .#moon --impure
      nixosConfigurations.moon = let
        system = "x86_64-linux";
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

          # packages
          ./pkgs/common.nix
          ./pkgs/1password.nix
        ];
      };

      # home-manager switch --flake .#moon --impure
      homeConfigurations.moon = let
        system = "x86_64-linux";
      in home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs system user; };
        pkgs = nixpkgs-unstable.legacyPackages.${system};
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
          }

          ./home-manager/${user}.nix

          ./home-manager/programs/chromium.nix
          ./home-manager/programs/fzf.nix
          ./home-manager/programs/git.nix
          ./home-manager/programs/nixvim.nix
          ./home-manager/programs/vscode.nix
          ./home-manager/programs/zoxide.nix
          ./home-manager/programs/zsh.nix
        ];
      };

      # nix run nix-darwin -- switch --flake .#Romans-MacBook-Pro
      # darwin-rebuild build --flake .#Romans-MacBook-Pro
      darwinConfigurations."Romans-MacBook-Pro" = let
        system = "aarch64-darwin";
      in nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs system user; };
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            system.stateVersion = 5;
          }

          # basic configuration & users
          ./hosts/romans-macbook-pro/configuration.nix

          # packages
          ./pkgs/common.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.extraSpecialArgs = { inherit inputs system user; };
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.${user} = import ./home-manager/${user}.nix;
          }
        ];
      };

    };
}
