{ ... }:

{
  services.github-runner = {
    enable = true;
    name = "sun";
    url = "https://github.com/lix-one";
    tokenFile = "/data/github-runner.conf";
    # extraPackages = [
    #   pkgs.openssh
    #   pkgs.git
    #   pkgs.psmisc
    # ];
    # extraEnvironment = {
    #   TMP = "/tmp";
    #   TMPDIR = "/tmp";
    #   ANSIBLE_LOCAL_TEMP = "/tmp";
    # };
  };
}
