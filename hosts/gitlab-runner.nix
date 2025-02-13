{ ... }:

{
  services.gitlab-runner = {
    enable = true;
    settings = { concurrent = 100; };
    services = {
      sun = {
        # $ cat /data/gitlab-runner.conf
        # CI_SERVER_URL=https://gitlab.com
        # CI_SERVER_TOKEN=glrt-***
        authenticationTokenConfigFile = "/data/gitlab-runner.conf";
        executor = "shell";
        limit = 0; # do not limit
      };
    };
  };
}
