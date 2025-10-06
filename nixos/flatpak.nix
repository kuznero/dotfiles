{ pkgs, ... }:

{
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo --user
  # flatpak update
  # flatpak search xmind
  # flatpak install flathub net.xmind.XMind
  services.flatpak.enable = true;

  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [ xdg-desktop-portal-gtk ];

  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
