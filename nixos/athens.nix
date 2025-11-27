{ pkgs, ... }:

{
  services.athens = {
    enable = true;
    goEnv = "production";
    logLevel = "info";

    # Storage configuration
    storageType = "disk";
    disk.rootPath = "/data/packages/go";

    # Network configuration
    port = 3000;

    # Use upstream proxy on cache miss
    downloadMode = "async_redirect";
    downloadURL = "https://proxy.golang.org";
  };

  # Open firewall for local network access if needed
  # networking.firewall.allowedTCPPorts = [ 3000 ];
}
