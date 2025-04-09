{ config, pkgs, ... }:

{
  xfconf.settings = {

    # command: xfconf-query -c xfce4-keyboard-shortcuts -l -v | xclip -sel clip
    xfce4-keyboard-shortcuts = {
      "commands/custom/Print" = "xfce4-screenshooter";
      "commands/custom/<Shift>Print" = "xfce4-screenshooter -r";
      "commands/custom/<Alt>Print" = "xfce4-screenshooter -w";
      "commands/custom/<Primary>Escape" = "xfdesktop --menu";
      "commands/custom/<Primary><Shift>Escape" = "xfce4-taskmanager";
      "commands/custom/<Super>t" = "ghostty";
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

    # command: xfconf-query -c xfce4-desktop -l -v | xclip -sel clip
    xfce4-desktop = {
      "backdrop/screen0/monitorDP-3-1-8/workspace0/color-style" = 0;
      "backdrop/screen0/monitorDP-3-1-8/workspace0/image-style" = 5;
      "backdrop/screen0/monitorDP-3-1-8/workspace0/last-image" =
        "/home/${config.home.username}/.config/wallpapers/xfce-leaves.svg";
      "backdrop/screen0/monitoreDP-1/workspace0/color-style" = 0;
      "backdrop/screen0/monitoreDP-1/workspace0/image-style" = 5;
      "backdrop/screen0/monitoreDP-1/workspace0/last-image" =
        "/home/${config.home.username}/.config/wallpapers/xfce-leaves.svg";
    };

    # command: xfconf-query -c xfce4-power-manager -l -v | xclip -sel clip
    xfce4-power-manager = {
      "xfce4-power-manager/brightness-switch" = 0;
      "xfce4-power-manager/brightness-switch-restore-on-exit" = 1;
      "xfce4-power-manager/dpms-enabled" = false;
      "xfce4-power-manager/general-notification" = true;
      "xfce4-power-manager/lid-action-on-ac" = 0;
      "xfce4-power-manager/lid-action-on-battery" = 0;
      "xfce4-power-manager/lock-screen-suspend-hibernate" = true;
      "xfce4-power-manager/logind-handle-hibernate-key" = true;
      "xfce4-power-manager/logind-handle-lid-switch" = true;
      "xfce4-power-manager/logind-handle-power-key" = true;
      "xfce4-power-manager/logind-handle-suspend-key" = true;
      "xfce4-power-manager/show-tray-icon" = false;
    };

  };
}
