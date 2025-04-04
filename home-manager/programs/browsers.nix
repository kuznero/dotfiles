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

  # ref: https://github.com/zbioe/dotnix/blob/33bb4a80ea69def119e40ee2766c092d52bbc96f/hosts/ln/firefox/settings.nix
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    policies = {
      OfferToSaveLogins = false;
      PasswordManagerEnabled = false;
      DisableTelemetry = true;
      DisableFirefoxStudies = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      DisablePocket = true;
      # DisableFirefoxAccounts = true;
      # DisableAccounts = true;
      # DisableFirefoxScreenshots = true;
      # OverrideFirstRunPage = "";
      # OverridePostUpdatePage = "";
      # DontCheckDefaultBrowser = true;
      DisplayBookmarksToolbar = "newtab";
      # DisplayMenuBar = "default-off";
      SearchBar = "unified";
    };
    profiles = {
      "${config.home.username}" = {
        id = 0;
        isDefault = true;
        # ref: https://gitlab.com/rycee/nur-expressions/-/blob/master/pkgs/firefox-addons/addons.json?ref_type=heads
        extensions.packages = with inputs.firefox-addons.packages."${system}"; [
          onepassword-password-manager
          darkreader
          multi-account-containers
          react-devtools
          stylus
          ublock-origin
          user-agent-string-switcher
        ];
        settings = {
          # auto enable extensions
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 15;
        };
        userChrome = builtins.readFile ./firefox/userChrome.css;
        # bookmarks = import ./firefox/bookmarks.nix;
        # search = {
        #   default = "Google";
        #   engines = import ./firefox/searchEngines.nix { inherit pkgs; };
        #   force = true;
        # };
      };
      "safe" = {
        id = 1;
        isDefault = false;
        settings = {
          # auto enable extensions
          "extensions.autoDisableScopes" = 0;
          "extensions.enabledScopes" = 15;
        } // import ./firefox/settings.nix;
        # userChrome = builtins.readFile ./firefox/userChrome.css;
        # bookmarks = import ./firefox/bookmarks.nix;
        # search = {
        #   default = "Google";
        #   engines = import ./firefox/searchEngines.nix { inherit pkgs; };
        #   force = true;
        # };
      };
      clean = {
        isDefault = false;
        id = 2;
      };
    };
  };
}
