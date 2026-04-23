{
  description = "Roku Labs NixOS and Home-Manager flake";

  inputs = {
    nixpkgs = { url = "github:nixos/nixpkgs/nixos-unstable"; };
    nixpkgs-stable = { url = "github:NixOS/nixpkgs?ref=nixos-25.11"; };
    # ref: https://github.com/NixOS/nixos-hardware/tree/master
    nixos-hardware = { url = "github:NixOS/nixos-hardware/master"; };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-stable, nixos-hardware, home-manager
    , nixvim }@inputs:
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

      openvpn3ProtobufOverlay = final: prev: {
        openvpn3 = prev.openvpn3.overrideAttrs (old: {
          buildInputs = builtins.map (pkg:
            if pkg == prev.protobuf then prev.protobuf_33 else pkg) old.buildInputs;
        });
      };

      patchedHomeManagerFilesModule = args@{ pkgs, ... }:
        import "${home-manager.outPath}/modules/files.nix" (args // {
          pkgs = pkgs // { xorg = { lndir = pkgs.lndir; }; };
        });

      patchedHomeManagerManualModule = { lib, ... }: {
        options = {
          manual.html.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to install the Home Manager HTML manual.";
          };

          manual.manpages.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to install the Home Manager man page.";
          };

          manual.json.enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            description = "Whether to install the Home Manager options JSON file.";
          };
        };
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
            specialArgs = {
              inherit inputs system user userName;
            };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                nixpkgs.overlays = [ openvpn3ProtobufOverlay ];
                system.stateVersion = "25.11";
              }

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
              # ./nixos/podman.nix
              ./nixos/vpn.nix

              # packages
              ./nixos/1password.nix
            ];
          };

        sun = # sudo nixos-rebuild switch --flake .#sun --impure
          let system = "x86_64-linux";
          in nixpkgs.lib.nixosSystem {
            specialArgs = {
              inherit inputs system user userName;
            };
            modules = [
              {
                nixpkgs.config.allowUnfree = true;
                nixpkgs.overlays = [ openvpn3ProtobufOverlay ];
                system.stateVersion = "25.11";
              }

              # basic configuration & users
              ./nixos/sun/configuration.nix
              ./nixos/user.nix

              # features
              ./nixos/docker.nix
              ./nixos/logind.nix
              ./nixos/github-runner.nix
              ./nixos/onlyoffice-server.nix
              ./nixos/athens.nix
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
            extraSpecialArgs = {
              inherit system user userName pkgs-stable;
            };
            pkgs = nixpkgs.legacyPackages.${system};
            modules = [
              { nixpkgs.config.allowUnfree = true; }

              ./home/user.nix
              ./home/browsers.nix
              ./home/common.nix
              ./home/dotfiles.nix
              ./home/fzf.nix
              ./home/git.nix
              # ./home/messengers.nix
              (import ./home/nixvim/default.nix {
                nixvim = nixvim;
                pkgs = nixpkgs.legacyPackages.${system};
              })
              # ./home/obsidian.nix
              # ./home/office.nix
              # ./home/pcloud.nix
              ./home/scripts.nix
              # ./home/spotify.nix
              ./home/tmux.nix
              # ./home/transmission.nix
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
          in home-manager.lib.homeManagerConfiguration {
            extraSpecialArgs = {
              inherit system user userName pkgs-stable;
            };
            pkgs = pkgs;
            modules = [
              {
                disabledModules = [ "files.nix" "manual.nix" ];
                imports = [ patchedHomeManagerFilesModule patchedHomeManagerManualModule ];
              }
              { nixpkgs.config.allowUnfree = true; }

              ./home/user.nix
              ./home/common.nix
              ./home/dotfiles.nix
              ./home/fzf.nix
              ./home/git.nix
              (import ./home/nixvim/default.nix {
                nixvim = nixvim;
                pkgs = pkgs;
              })
              ./home/scripts.nix
              ./home/tmux.nix
              ./home/yabai.nix
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
