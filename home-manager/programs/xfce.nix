{ pkgs, ... }:

{
  xfconf.settings = {
    # command: xfconf-query -c xfce4-keyboard-shortcuts -l -v | xclip -sel clip
    xfce4-keyboard-shortcuts = {
      "commands/custom/Print" = "xfce4-screenshooter";
      "commands/custom/<Shift>Print" = "xfce4-screenshooter -r";
      "commands/custom/<Alt>Print" = "xfce4-screenshooter -w";
      "commands/custom/<Primary>Escape" = "xfdesktop --menu";
      "commands/custom/<Primary><Shift>Escape" = "xfce4-taskmanager";
      "commands/custom/<Super>t" = "exo-open --launch TerminalEmulator";
      "commands/custom/<Super>b" = "firefox";
      "commands/custom/<Super>e" = "thunar";
      "commands/custom/<Super>p" = "xfce4-display-settings --minimal";
      "commands/custom/<Super>r" = "xfce4-appfinder";
      "commands/custom/<Super>r/startup-notify" = "true";
      "commands/custom/<Super>l" = "xflock4";
      "xfwm4/custom/<Super>d" = "show_desktop_key";
      "xfwm4/custom/<Super>1" = "workspace_1_key";
      "xfwm4/custom/<Super>2" = "workspace_2_key";
      "xfwm4/custom/<Super>3" = "workspace_3_key";
      "xfwm4/custom/<Super>4" = "workspace_4_key";
      "xfwm4/custom/<Super>5" = "workspace_5_key";
      "xfwm4/custom/<Super>6" = "workspace_6_key";
      "xfwm4/custom/<Super>7" = "workspace_7_key";
      "xfwm4/custom/<Super>8" = "workspace_8_key";
      "xfwm4/custom/<Super>9" = "workspace_9_key";
      "xfwm4/custom/<Super>0" = "workspace_10_key";
    };
    # xfce4-session = { "startup/ssh-agent/enabled" = false; };
    # xfce4-desktop = {
    #   "backdrop/screen0/monitorLVDS-1/workspace0/last-image" =
    #     "${pkgs.nixos-artwork.wallpapers.stripes-logo.gnomeFilePath}";
    # };
  };
}
