{ pkgs, system, ... }:

{
  programs.chromium = {
    enable = builtins.match ".*-linux" system != null;
    package = pkgs.chromium;
    extensions = [
      "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
      "bhchdcejhohfmigjafbampogmaanbfkg" # User-Agent Switcher and Manager
      "cnjifjpddelmedmihgijeibhnjfabmlf" # Obsidian
      "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
      "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture Extension (by Google)
    ];
  };
}
