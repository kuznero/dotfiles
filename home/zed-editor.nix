{ pkgs, lib, ... }:

{
  programs.zed-editor = {
    enable = true;
    package = pkgs.zed-editor;
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

      theme = {
        mode = "system";
        light = lib.mkForce "Catppuccin Latte";
        dark = lib.mkForce "Catppuccin Mocha";
      };

      ui_font_family = ".SystemUIFont";
      ui_font_size = 21;
      ui_font_weight = 400;

      buffer_font_family = "Hurmit Nerd Font";
      buffer_font_size = 18;
      buffer_font_weight = 400;

      terminal = {
        font_family = "Hurmit Nerd Font";
        font_size = 18;
        line_height = "standard";
        shell = { program = "zsh"; };
      };

      vim_mode = true;

      languages = { Nix = { language_servers = [ "nixd" "!nil" ]; }; };
    };
  };
}
