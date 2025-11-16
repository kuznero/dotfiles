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
      disable_ai = false;

      theme = {
        mode = "system";
        light = lib.mkForce "Catppuccin Latte";
        dark = lib.mkForce "Catppuccin Mocha";
      };

      agent_ui_font_family = ".SystemUIFont";
      agent_ui_font_size = 18;
      agent_ui_font_weight = 400;

      agent_buffer_font_family = "Hurmit Nerd Font";
      agent_buffer_font_size = 18;
      agent_buffer_font_weight = 400;

      ui_font_family = ".SystemUIFont";
      ui_font_size = 18;
      ui_font_weight = 400;

      buffer_font_family = "Hurmit Nerd Font";
      buffer_font_size = 18;
      buffer_font_weight = 400;

      terminal = {
        font_family = "Hurmit Nerd Font";
        font_size = 18;
        # Terminal line height: comfortable (1.618), standard(1.3) or `{ "custom": 2 }`
        line_height = "standard";
      };

      vim_mode = true;
    };
  };
}
