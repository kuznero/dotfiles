{ lib, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.gnome.gnome-settings-daemon.enable = true;

  environment.systemPackages = with pkgs; [
    gnome.dconf-editor
    gnome.gnome-tweaks
    gnomeExtensions.appindicator
  ];

  programs.dconf = {
    enable = true;
    profiles = {
      user.databases = [{
        settings = with lib.gvariant; {
          "org/gnome/desktop/privacy".remember-recent-files = false;
          "org/gnome/desktop/interface".color-scheme = "prefer-dark";
          "org/gnome/shell/keybindings".show-screen-recording-ui = ["<Shift><Super>s"];
          "org/gnome/desktop/interface".font-hinting = "full";
          "org/gnome/desktop/interface".font-antialiasing = "rgba";
          "org/gnome/desktop/wm/preferences".num-workspaces = mkInt32 2;

          "org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
          "org/gnome/settings-daemon/plugins/power".power-button-action = "nothing";

          "org/gnome/shell".enabled-extensions = [
            "apps-menu@gnome-shell-extensions.gcampax.github.com"
            "system-monitor@gnome-shell-extensions.gcampax.github.com"
            "appindicatorsupport@rgcjonas.gmail.com"
            "workspace-indicator@gnome-shell-extensions.gcampax.github.com"
          ];

          "org/gnome/desktop/input-sources" = {
            sources = [ (mkTuple [ "xkb" "us" ]) (mkTuple [ "xkb" "ru" ]) ];
          };

          "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = [
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/"
            "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/"
          ];

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
            binding = "<Super>t";
            command = "kitty";
            name    = "Open Terminal";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1" = {
            binding = "<Super>b";
            command = "chromium";
            name    = "Open Browser";
          };

          "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2" = {
            binding = "<Super>e";
            command = "nautilus";
            name    = "Open Files";
          };
        };
      }];
    };
  };
}
