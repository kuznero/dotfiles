{ config, ... }:

{
  services.github-runners.${config.networking.hostName} = {
    enable = true;
    ephemeral = true;
    replace = true;
    tokenFile = "/data/github-runner.conf";
    url = "https://github.com/lix-one";
    concurrent = 10;
    extraLabels = [ "sun" ];
    # extraPackages = with pkgs; [ cachix ];
  };
}
