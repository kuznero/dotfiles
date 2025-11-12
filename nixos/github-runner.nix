{ config, pkgs, lib, ... }:

let
  amountOfRunners = 50;
  runnerServiceOverrides = {
    CapabilityBoundingSet = [
      "CAP_AUDIT_CONTROL"
      "CAP_AUDIT_READ"
      "CAP_AUDIT_WRITE"
      "CAP_BLOCK_SUSPEND"
      "CAP_BPF"
      "CAP_CHECKPOINT_RESTORE"
      "CAP_CHOWN"
      "CAP_DAC_OVERRIDE"
      "CAP_DAC_READ_SEARCH"
      "CAP_FOWNER"
      "CAP_FSETID"
      "CAP_IPC_LOCK"
      "CAP_IPC_OWNER"
      "CAP_KILL"
      "CAP_LEASE"
      "CAP_LINUX_IMMUTABLE"
      "CAP_MAC_ADMIN"
      "CAP_MAC_OVERRIDE"
      "CAP_MKNOD"
      "CAP_NET_ADMIN"
      "CAP_NET_BIND_SERVICE"
      "CAP_NET_BROADCAST"
      "CAP_NET_RAW"
      "CAP_PERFMON"
      "CAP_SETFCAP"
      "CAP_SETGID"
      "CAP_SETPCAP"
      "CAP_SETUID"
      "CAP_SYSLOG"
      "CAP_SYS_ADMIN"
      "CAP_SYS_BOOT"
      "CAP_SYS_CHROOT"
      "CAP_SYS_MODULE"
      "CAP_SYS_NICE"
      "CAP_SYS_PACCT"
      "CAP_SYS_PTRACE"
      "CAP_SYS_RAWIO"
      "CAP_SYS_RESOURCE"
      "CAP_SYS_TIME"
      "CAP_SYS_TTY_CONFIG"
      "CAP_WAKE_ALARM"
    ];

    DynamicUser = "no";
    User = "github-runner";
    Group = "github-runner";

    BindPaths = [ "/var/run/docker.sock" ];

    Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin";
    NoNewPrivileges = "yes";

    PrivateDevices = "no";
    PrivateIPC = "no";
    PrivateMounts = "no";
    PrivateNetwork = "no";
    PrivateTmp = "yes";
    PrivateUsers = "no";

    ProcSubset = "all";

    ProtectClock = "no";
    ProtectControlGroups = "no";
    ProtectHome = "read-only";
    ProtectHostname = "no";
    ProtectKernelLogs = "no";
    ProtectKernelModules = "no";
    ProtectKernelTunables = "no";
    ProtectProc = "default";
    ProtectSystem = "strict";

    RemoveIPC = "yes";

    RestrictNamespaces = "no";
    RestrictRealtime = "no";
    RestrictSUIDSGID = "yes";

    Restart = lib.mkForce "always";
    RestartSec = "10s";
  };
in {
  environment.systemPackages = with pkgs; [ coreutils-full ];

  users.groups.github-runner = { };

  users.users.github-runner = {
    isSystemUser = true;
    description = "GitHub Runner";
    group = "github-runner";
    extraGroups = [ "docker" ];
  };

  services.github-runners = lib.listToAttrs (map (n: rec {
    name = "${config.networking.hostName}-${toString n}";
    value = {
      enable = true;
      ephemeral = true;
      replace = true;
      tokenFile = "/data/github-runner.conf";
      url = "https://github.com/lix-one";
      extraLabels = [ "${config.networking.hostName}" ];
      workDir =
        "/data/github-runner-work/${config.networking.hostName}-${toString n}";
      # extraPackages = with pkgs; [ cachix ];
      serviceOverrides = runnerServiceOverrides;
    };
  }) (lib.range 1 amountOfRunners));

  systemd.services = lib.listToAttrs (map (n: rec {
    name = "github-runners-${config.networking.hostName}-${toString n}";
    value = { path = [ "/run/wrappers" "/run/current-system/sw/bin" ]; };
  }) (lib.range 1 amountOfRunners));

  # services.github-runners."${config.networking.hostName}-1" = {
  #   enable = true;
  #   ephemeral = true;
  #   replace = true;
  #   tokenFile = "/data/github-runner.conf";
  #   url = "https://github.com/lix-one";
  #   extraLabels = [ "${config.networking.hostName}" ];
  #   # extraPackages = with pkgs; [ cachix ];
  #   serviceOverrides = runnerServiceOverrides;
  # };
  #
  # systemd.services."github-runners-${config.networking.hostName}-1".path =
  #   [ "/run/wrappers" "/run/current-system/sw/bin" ];
}
