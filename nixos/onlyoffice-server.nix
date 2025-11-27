{ config, pkgs, user, ... }:

{
  services.onlyoffice = {
    enable = true;
    package = pkgs.onlyoffice-documentserver;
    port = 8111;
    hostname = "onlyoffice.lix.one";
    # NOTE: generate with `openssl rand -hex 32`
    # NOTE: when JWT is re-generated, make sure to `sudo systemctl restart onlyoffice-documentserver`
    jwtSecretFile = "/data/onlyoffice-secret.jwt";
    # NOTE: generate with `openssl rand -hex 32`
    securityNonceFile = "/data/onlyoffice-security.nonce";
  };

  security.acme.defaults.email = "${user}@lix.one";
  security.acme.acceptTerms = true;

  networking.firewall.allowedTCPPorts = [ 80 443 ];

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
