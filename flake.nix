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

  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, nixvim }@inputs:
    let
      system = builtins.currentSystem or "x86_64-linux";
      user = "roku";
    in
    {
      # sudo nixos-rebuild switch --flake .#moon --impure
      nixosConfigurations.moon = nixpkgs.lib.nixosSystem {
        system = system;
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
      homeConfigurations.moon = home-manager.lib.homeManagerConfiguration {
        extraSpecialArgs = { inherit inputs system user; };
        pkgs = nixpkgs-unstable.legacyPackages.${system};
        modules = [
          {
            nixpkgs.config.allowUnfree = true;
            home.stateVersion = "24.05";
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

    };
}
