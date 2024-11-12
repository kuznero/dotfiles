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
      # ReadWritePaths = [
      #   "/nix"
      #   # "/nix/var/nix/profiles/per-user/" # https://github.com/cachix/cachix-ci-agents/blob/63f3f600d13cd7688e1b5db8ce038b686a5d29da/agents/linux.nix#L30C26-L30C59
      # ];

      # # BindPaths = [ "/proc:/proc:rbind" ]; # TODO: A/B teste!
      # BindPaths = [ "/proc" ];

      # IPAddressAllow = [
      #   "0.0.0.0/0"
      #   "::/0"
      # ]; # https://github.com/skogsbrus/os/blob/cced4b4dfc60d03168a2bf0ad5e4ca901c732136/sys/caddy.nix#L161
      # IPAddressDeny = [ ];
      # # Environment = [
      # #   "HOME=/var/lib/caddy"
      # # ];
      # # ExecStart = lib.mkForce "echo Hi, %u";
      # ProtectControlGroups = false;
      # # PrivateTmp = false;
      # PrivateUsers = false;
      # RestrictNamespaces = false;
      # DynamicUser = false; # TODO: A/B teste!
      # PrivateDevices = false;
      # PrivateMounts = false;
      # ProtectHome = "no";
      # ProtectSystem = "no"; # TODO: A/B teste!
      # ProtectHostname =
      #   false; # TODO: hardening, precisamos disso? Talvez nix buils precise!
      # # RemoveIPC = false;
      # MemoryDenyWriteExecute = "no"; # TODO: A/B teste!
      # PrivateNetwork =
      #   false; # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#PrivateNetwork= TODO: hardening https://github.com/NixOS/nixpkgs/pull/259056/files#diff-e70037b1f30ecb052931d6b896b8236a67d5ca92dbc8b2057d4f41a8bb70a7a4R308
      # RestrictRealtime = false;
      # # ProtectKernelLogs = false;
      # # ProtectKernelModules = false;
      # ProtectKernelTunables = false; # TODO: A/B teste!
      # ProtectProc =
      #   "default"; # https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html#ProtectProc=
      # # ProtectProc = "invisible"; # TODO: A/B teste!
      # # ProtectProc = "ptraceable"; # TODO: A/B teste!
      # SocketBindAllow = "any"; # TODO: A/B teste!
      # SystemCallArchitectures = ""; # TODO: A/B teste!

      # # https://www.redhat.com/sysadmin/mastering-systemd
      # # https://unix.stackexchange.com/a/581337
      # # https://man7.org/linux/man-pages/man7/capabilities.7.html
      # # https://medium.com/@maros.kukan/advanced-containers-with-podman-f79302de85b0
      # # https://linuxconfig.org/how-to-increase-the-security-of-systemd-services
      # # https://unix.stackexchange.com/a/639604
      # # https://nixos.wiki/wiki/Systemd_Hardening
      # # TODO: https://discourse.nixos.org/t/nginx-worker-processes-exit-with-signal-31-when-running-via-systemd/13471/7

      # # TODO: https://github.com/serokell/serokell.nix/blob/bfd859fcb96aa912f4ca05b4afe4082114ca9ec7/lib/systemd/profiles.nix#L5
      # # https://github.com/containers/podman/issues/4618
      # # https://manpages.debian.org/bullseye/manpages/capabilities.7.en.html#CAP_SYS_ADMIN
      # # https://docs.arbitrary.ch/security/systemd.html
      # # https://github.com/restic/rest-server/issues/148
      # # https://discussion.fedoraproject.org/t/f40-change-proposal-systemd-security-hardening-system-wide/96423
      # AmbientCapabilities = [
      #   "CAP_AUDIT_CONTROL"
      #   "CAP_AUDIT_WRITE"
      #   "CAP_BLOCK_SUSPEN"
      #   "CAP_CHOWN"
      #   "CAP_DAC_OVERRIDE"
      #   "CAP_DAC_READ_SEARCH"
      #   "CAP_FOWNER"
      #   "CAP_FSETID"
      #   "CAP_IPC_LOCK"
      #   "CAP_IPC_OWNER"
      #   "CAP_KILL"
      #   "CAP_LEASE"
      #   "CAP_LINUX_IMMUTABLE"
      #   "CAP_MAC_ADMIN"
      #   "CAP_MAC_OVERRIDE"
      #   "CAP_MKNOD"
      #   "CAP_NET_ADMIN"
      #   "CAP_NET_BIND_SERVICE"
      #   "CAP_NET_BROADCAST"
      #   "CAP_NET_RAW"
      #   "CAP_SETFCAP"
      #   "CAP_SETGID"
      #   "CAP_SETPCAP"
      #   "CAP_SETUID"
      #   "CAP_SYSLOG"
      #   "CAP_SYS_ADMIN"
      #   "CAP_SYS_BOOT"
      #   "CAP_SYS_CHROOT"
      #   "CAP_SYS_MODULE"
      #   "CAP_SYS_NICE"
      #   "CAP_SYS_PACCT"
      #   "CAP_SYS_PTRACE"
      #   "CAP_SYS_RAWIO"
      #   "CAP_SYS_RESOURCE"
      #   "CAP_SYS_TIME"
      #   "CAP_SYS_TTY_CONFIG"
      #   "CAP_WAKE_ALARM"
      # ];
      # CapabilityBoundingSet = [
      #   "CAP_AUDIT_CONTROL"
      #   "CAP_AUDIT_WRITE"
      #   "CAP_BLOCK_SUSPEN"
      #   "CAP_CHOWN"
      #   "CAP_DAC_OVERRIDE"
      #   "CAP_DAC_READ_SEARCH"
      #   "CAP_FOWNER"
      #   "CAP_FSETID"
      #   "CAP_IPC_LOCK"
      #   "CAP_IPC_OWNER"
      #   "CAP_KILL"
      #   "CAP_LEASE"
      #   "CAP_LINUX_IMMUTABLE"
      #   "CAP_MAC_ADMIN"
      #   "CAP_MAC_OVERRIDE"
      #   "CAP_MKNOD"
      #   "CAP_NET_ADMIN"
      #   "CAP_NET_BIND_SERVICE"
      #   "CAP_NET_BROADCAST"
      #   "CAP_NET_RAW"
      #   "CAP_SETFCAP"
      #   "CAP_SETGID"
      #   "CAP_SETPCAP"
      #   "CAP_SETUID"
      #   "CAP_SYSLOG"
      #   "CAP_SYS_ADMIN"
      #   "CAP_SYS_BOOT"
      #   "CAP_SYS_CHROOT"
      #   "CAP_SYS_MODULE"
      #   "CAP_SYS_NICE"
      #   "CAP_SYS_PACCT"
      #   "CAP_SYS_PTRACE"
      #   "CAP_SYS_RAWIO"
      #   "CAP_SYS_RESOURCE"
      #   "CAP_SYS_TIME"
      #   "CAP_SYS_TTY_CONFIG"
      #   "CAP_WAKE_ALARM"
      # ];

      # # https://man7.org/linux/man-pages/man7/address_families.7.html
      # RestrictAddressFamilies = [
      #   "AF_BRIDGE"
      #   "AF_UNIX"
      #   "AF_INET"
      #   "AF_NETLINK"
      #   "AF_INET6"
      #   "AF_XDP"
      # ]; # TODO: A/B teste! # https://github.com/containers/podman/discussions/14311
      # # RestrictAddressFamilies = [ "AF_UNIX" "AF_NETLINK" ]; # TODO: A/B teste! https://github.com/serokell/serokell.nix/blob/bfd859fcb96aa912f4ca05b4afe4082114ca9ec7/lib/systemd/profiles.nix#L34
      # /* The reason is that using RestrictAddressFamilies in an unprivileged systemd user service implies
      #    NoNewPrivileges=yes. This prevents /usr/bin/newuidmap and /usr/bin/newgidmap from running with
      #    elevated privileges. Podman executes newuidmap and newgidmap to set up user namespace. Both executables
      #    normally run with elevated privileges, as they need to perform operations not available to an
      #    unprivileged user.
      #    https://www.redhat.com/sysadmin/podman-systemd-limit-access
      # */
      # NoNewPrivileges =
      #   false; # https://docs.arbitrary.ch/security/systemd.html#nonewprivileges
      # SystemCallFilter = lib.mkForce
      #   [ ]; # Resolve ping -c 3 8.8.8.8 -> Bad system call (core dumped)
      # RestrictSUIDSGID = false;
      # # https://github.com/NixOS/nixpkgs/issues/18708#issuecomment-248254608
      # DeviceAllow = [ "auto" ];
      # https://discourse.nixos.org/t/how-to-add-path-into-systemd-user-home-manager-service/31623/4
      Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin";
    };
  };

  systemd.services."github-runners-${config.networking.hostName}".path =
    [ "/run/wrappers" "/run/current-system/sw/bin" ];
}
