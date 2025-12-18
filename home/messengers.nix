{ pkgs, system, ... }:

{
  home.packages = with pkgs;
    builtins.filter (pkg: pkg != null) [
      (if system != "aarch64-linux" then slack else null)
      (if system != "aarch64-darwin" then telegram-desktop else null)
      (if system != "aarch64-linux" then zoom-us else null)
      discord
    ];
}
