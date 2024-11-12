{ config, ... }:

{
  services.github-runners.${config.networking.hostName} = {
    enable = true;
    ephemeral = true;
    replace = true;
    tokenFile = "/data/github-runner.conf";
    url = "https://github.com/lix-one";
    extraLabels = [ "${config.networking.hostName}" ];
    # extraPackages = with pkgs; [ cachix ];
    serviceOverrides = {
      Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin";
    };
    serviceConfig = { User = "root"; };
  };

  systemd.services."github-runners-${config.networking.hostName}".path =
    [ "/run/wrappers" "/run/current-system/sw/bin" ];
}
