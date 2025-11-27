{ pkgs, ... }:

{
  services.athens = {
    enable = true;
    goEnv = "production";
    logLevel = "info";

    # Storage configuration
    # NOTE: ensure directory exists and is writable: sudo mkdir -p /data/packages/go && sudo chmod 777 /data/packages/go
    storageType = "disk";
    storage.disk.rootPath = "/data/packages/go";

    # Network configuration
    port = 3000;

    # Use upstream proxy on cache miss
    downloadMode = "sync";
    downloadURL = "https://proxy.golang.org";
  };

  # Open firewall for local network access if needed
  # networking.firewall.allowedTCPPorts = [ 3000 ];
}
