{ inputs, pkgs, ... }:

let pkgs-unstable = import inputs.nixpkgs-unstable { };
in {
  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama;
  };
}
