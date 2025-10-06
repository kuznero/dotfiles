{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    ffmpeg-full
    gimp-with-plugins
    imagemagick
    obs-studio
    vlc
  ];
}
