{ config, ... }:

{
  users.users."github-runner-sun" = {
    isNormalUser = true; # Ensure the user is a normal user
    extraGroups = [ "docker" ]; # Add the user to the docker group
  };

  services.github-runners.${config.networking.hostName} = {
    enable = true;
    ephemeral = true;
    replace = true;
    tokenFile = "/data/github-runner.conf";
    url = "https://github.com/lix-one";
    extraLabels = [ "sun" ];
    # extraPackages = with pkgs; [ cachix ];
  };
}
