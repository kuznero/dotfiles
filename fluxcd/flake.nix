{
  description = "FluxCD Playground";

  inputs = {
    nixpkgs-stable.url = "github:NixOS/nixpkgs?ref=nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs-stable, nixpkgs-unstable, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs-stable = import nixpkgs-stable {
          inherit system;
          config = { allowUnfree = true; };
        };
        pkgs-unstable = import nixpkgs-unstable {
          inherit system;
          config = { allowUnfree = true; };
        };
        ci-inputs = with pkgs-unstable; [
          age
          cilium-cli
          docker-client
          docker-compose
          fluxcd
          gitFull
          gnupg
          go-task
          kind
          kubectl
          kubectl-cnpg
          kubernetes-helm
          shellcheck
          sops
        ];
        dev-inputs = ci-inputs
          ++ (with pkgs-unstable; [ k9s lazydocker lazygit zsh ]);
      in {
        formatter = pkgs-unstable.nixfmt-classic;
        devShells = {
          default = pkgs-unstable.mkShell {
            hardeningDisable = [ "fortify" ];
            buildInputs = dev-inputs;
            shellHook = ''
              temp_dir=$(mktemp -d)
              cp $HOME/.zshenv $temp_dir/.zshenv || touch $temp_dir/.zshenv
              cp $HOME/.zshrc $temp_dir/.zshrc || touch $temp_dir/.zshrc
              chmod 0644 $temp_dir/.zshenv $temp_dir/.zshrc

              export NIX_FLAKE_NAME="FluxCD Playground"
              export PATH="$(pwd)/scripts:$PATH"

              cat <<EOF >> $temp_dir/.zshrc
              export NIX_FLAKE_NAME="FluxCD Playground"
              export PATH="${toString self}/scripts:$PATH"
              alias t=task
              . <(kind completion zsh)
              . <(flux completion zsh)
              EOF

              ZDOTDIR=$temp_dir exec ${pkgs-unstable.zsh}/bin/zsh
            '';
          };
          ci = pkgs-unstable.mkShell {
            hardeningDisable = [ "fortify" ];
            buildInputs = dev-inputs;
          };
        };
      });
}
