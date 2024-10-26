{ pkgs, system, ... }:

{
  programs.chromium = {
    enable = builtins.match ".*-linux" system != null;
    package = pkgs.chromium;
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "bhchdcejhohfmigjafbampogmaanbfkg" # User-Agent Switcher and Manager
    ];
  };
}
