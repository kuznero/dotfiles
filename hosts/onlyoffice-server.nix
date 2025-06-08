{ config, pkgs, ... }:

{
  services.onlyoffice = {
    enable = true;
    package = pkgs.onlyoffice-documentserver;
    port = 8111;
    hostname = "onlyoffice.lix.one";
    jwtSecretFile = "/data/onlyoffice-secret.jwt";
  };

  # otherwise this leads to nginx
  # open() "/var/lib/onlyoffice/documentserver/App_Data/cache/files/data/conv_check_1138411943_docx/output.docx" failed (13: Permission denied)
  # and mysterious 403 errors
  system.activationScripts.onlyoffice-readable.text = ''
    chmod a+x /var/lib/onlyoffice/documentserver/
  '';

  services.nginx.virtualHosts.${config.services.onlyoffice.hostname} = {
    enableACME = true;
    forceSSL = true;
  };
}
