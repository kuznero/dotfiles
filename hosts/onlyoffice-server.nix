{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ onlyoffice-documentserver ];
}
