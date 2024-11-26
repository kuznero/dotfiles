{ ... }:

{
  services.gitlab-runner = {
    enable = true;
    clear-docker-cache.enable = true;
    clear-docker-cache.dates = "weekly";
    settings = { concurrent = 100; };
    services = {
      sun = {
        # $ cat /data/gitlab-runner.conf
        # CI_SERVER_URL=https://gitlab.com
        # CI_SERVER_TOKEN=glrt-***
        authenticationTokenConfigFile = "/data/gitlab-runner.conf";
        executor = "docker";
        limit = 0; # do not limit
        dockerImage = "alpine:3.18.5";
        dockerPrivileged = true;
        dockerVolumes =
          [ "/var/run/docker.sock:/var/run/docker.sock" "/data/cache" ];
      };
      sun-shell = {
        # $ cat /data/gitlab-runner.conf
        # CI_SERVER_URL=https://gitlab.com
        # CI_SERVER_TOKEN=glrt-***
        authenticationTokenConfigFile = "/data/gitlab-runner-shell.conf";
        executor = "shell";
        limit = 0; # do not limit
      };
    };
  };
}
