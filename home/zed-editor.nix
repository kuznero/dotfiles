{ pkgs, pkgs-zed, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    # Use pinned nixpkgs for binary cached version
    package = pkgs-zed.zed-editor;
    mutableUserSettings = true;
    extensions = [
      "catppuccin"
      "catppuccin-icons"
      "golangci-lint"
      "gosum"
      "gotmpl"
      "mermaid"
      "nix"
    ];
    extraPackages = [ pkgs.nixd ];
    userSettings = {
      disable_ai = true;
      agent = { enabled = false; };

      theme = lib.mkForce {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      icon_theme = lib.mkForce {
        mode = "system";
        light = "Catppuccin Latte";
        dark = "Catppuccin Mocha";
      };

      ui_font_family = ".SystemUIFont";
      ui_font_size = 21;
      ui_font_weight = 400;

      buffer_font_family = "Hurmit Nerd Font";
      buffer_font_size = 18;
      buffer_font_weight = 400;
      buffer_line_height = "standard";

      restore_on_startup = "none";

      git_panel = { sort_by_path = true; };

      terminal = {
        font_family = "Hurmit Nerd Font";
        font_size = 18;
        line_height = "standard";
        shell = { program = "zsh"; };
      };

      vim_mode = true;

      languages = {
        Go = {
          inlay_hints = {
            show_background = true;
            enabled = true;
          };
        };
        Nix = { language_servers = [ "nixd" "!nil" ]; };
      };

      lsp = {
        gopls = {
          initialization_options = {
            buildFlags = [ "-tags=unit,integration,e2e,benchmark" ];
          };
        };
      };
    };
  };
}
