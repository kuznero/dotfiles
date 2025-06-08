{ pkgs, ... }:

{
  services.onlyoffice = {
    enable = true;
    package = pkgs.onlyoffice-documentserver;
    hostname = "0.0.0.0";
  };
}
