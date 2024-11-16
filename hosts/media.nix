{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ vlc ffmpeg-full ];
}
