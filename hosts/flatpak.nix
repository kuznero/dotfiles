{ ... }:

{
  # flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
  # flatpak update
  # flatpak search xmind
  # flatpak install flathub net.xmind.XMind
  services.flatpak.enable = true;
}
