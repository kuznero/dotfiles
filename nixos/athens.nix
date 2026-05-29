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

    # Fetch cache misses through the public Go proxy instead of direct VCS access.
    filterFile = pkgs.writeText "athens-filter" "D\n";
    globalEndpoint = "https://proxy.golang.org";

    # Avoid client-facing 500s on uncached bursts; warm cache in the background.
    downloadMode = "async_redirect";
    downloadURL = "https://proxy.golang.org";
  };

  # Open firewall for local network access if needed
  # networking.firewall.allowedTCPPorts = [ 3000 ];
}
