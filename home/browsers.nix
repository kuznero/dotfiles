{ config, inputs, pkgs, system, ... }:

{
  # programs.chromium = {
  #   enable = builtins.match ".*-linux" system != null;
  #   package = pkgs.chromium;
  #   extensions = [
  #     "aeblfdkhhhdcdjpifhhbdiojplfjncoa" # 1Password
  #     "bhchdcejhohfmigjafbampogmaanbfkg" # User-Agent Switcher and Manager
  #     "cnjifjpddelmedmihgijeibhnjfabmlf" # Obsidian
  #     "eimadpbcbfnmbkopoojfekhnkhdbieeh" # Dark Reader
  #     "fmkadmapgofadopljbjfkapdkoienihi" # React Developer Tools
  #     "hkgfoiooedgoejojocmhlaklaeopbecg" # Picture-in-Picture Extension (by Google)
  #     "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
  #   ];
  # };

  programs.brave = {
    enable = true;
    commandLineArgs = [ "--no-default-browser-check" "--restore-last-session" ];
    extensions = [
      {
        # 1Password
        id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa";
      }
      {
        # User-Agent Switcher and Manager
        id = "bhchdcejhohfmigjafbampogmaanbfkg";
      }
      {
        # Obsidian
        id = "cnjifjpddelmedmihgijeibhnjfabmlf";
      }
      {
        # Dark Reader
        id = "eimadpbcbfnmbkopoojfekhnkhdbieeh";
      }
      {
        # React Developer Tools
        id = "fmkadmapgofadopljbjfkapdkoienihi";
      }
      {
        # Picture-in-Picture Extension (by Google)
        id = "hkgfoiooedgoejojocmhlaklaeopbecg";
      }
      {
        # Stylus
        id = "clngdbkpkpeebahjckkjfobafhncgmne";
      }
    ];
  };
}
