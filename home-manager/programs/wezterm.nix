{ pkgs, ... }:

{
  programs.wezterm = {
    enable = true;

    enableBashIntegration = true;
    enableZshIntegration = true;

    colorSchemes = {
      # ref: https://github.com/catppuccin/wezterm/blob/main/dist/catppuccin-mocha.toml
      catpuccin-mocha = {
        ansi = [ "#45475a" "#f38ba8" "#a6e3a1" "#f9e2af" "#89b4fa" "#f5c2e7" "#94e2d5" "#bac2de" ];
        background = "#1e1e2e";
        brights = [ "#585b70" "#f38ba8" "#a6e3a1" "#f9e2af" "#89b4fa" "#f5c2e7" "#94e2d5" "#a6adc8" ];
        compose_cursor = "#f2cdcd";
        cursor_bg = "#f5e0dc";
        cursor_border = "#f5e0dc";
        cursor_fg = "#11111b";
        foreground = "#cdd6f4";
        scrollbar_thumb = "#585b70";
        selection_bg = "#585b70";
        selection_fg = "#cdd6f4";
        split = "#6c7086";
        visual_bell = "#313244";

        indexed = {
          "16" = "#fab387";
          "17" = "#f5e0dc";
        };

        tab_bar = {
          background = "#11111b";
          inactive_tab_edge = "#313244";
        };

        tab_bar.active_tab = {
          bg_color = "#cba6f7";
          fg_color = "#11111b";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab = {
          bg_color = "#181825";
          fg_color = "#cdd6f4";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab_hover = {
          bg_color = "#1e1e2e";
          fg_color = "#cdd6f4";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab = {
          bg_color = "#313244";
          fg_color = "#cdd6f4";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab_hover = {
          bg_color = "#45475a";
          fg_color = "#cdd6f4";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };
      };

      # ref: https://github.com/catppuccin/wezterm/blob/main/dist/catppuccin-macchiato.toml
      catpuccin-macchiato = {
        ansi = [ "#494d64" "#ed8796" "#a6da95" "#eed49f" "#8aadf4" "#f5bde6" "#8bd5ca" "#b8c0e0" ];
        background = "#24273a";
        brights = [ "#5b6078" "#ed8796" "#a6da95" "#eed49f" "#8aadf4" "#f5bde6" "#8bd5ca" "#a5adcb" ];
        compose_cursor = "#f0c6c6";
        cursor_bg = "#f4dbd6";
        cursor_border = "#f4dbd6";
        cursor_fg = "#181926";
        foreground = "#cad3f5";
        scrollbar_thumb = "#5b6078";
        selection_bg = "#5b6078";
        selection_fg = "#cad3f5";
        split = "#6e738d";
        visual_bell = "#363a4f";

        indexed = {
          "16" = "#f5a97f";
          "17" = "#f4dbd6";
        };

        tab_bar = {
          background = "#181926";
          inactive_tab_edge = "#363a4f";
        };

        tab_bar.active_tab = {
          bg_color = "#c6a0f6";
          fg_color = "#181926";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab = {
          bg_color = "#1e2030";
          fg_color = "#cad3f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab_hover = {
          bg_color = "#24273a";
          fg_color = "#cad3f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab = {
          bg_color = "#363a4f";
          fg_color = "#cad3f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab_hover = {
          bg_color = "#494d64";
          fg_color = "#cad3f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };
      };

      # ref: https://github.com/catppuccin/wezterm/blob/main/dist/catppuccin-latte.toml
      catpuccin-latte = {
        ansi = [ "#bcc0cc" "#d20f39" "#40a02b" "#df8e1d" "#1e66f5" "#ea76cb" "#179299" "#5c5f77" ];
        background = "#eff1f5";
        brights = [ "#acb0be" "#d20f39" "#40a02b" "#df8e1d" "#1e66f5" "#ea76cb" "#179299" "#6c6f85" ];
        compose_cursor = "#dd7878";
        cursor_bg = "#dc8a78";
        cursor_border = "#dc8a78";
        cursor_fg = "#dce0e8";
        foreground = "#4c4f69";
        scrollbar_thumb = "#acb0be";
        selection_bg = "#acb0be";
        selection_fg = "#4c4f69";
        split = "#9ca0b0";
        visual_bell = "#ccd0da";

        indexed = {
          "16" = "#fe640b";
          "17" = "#dc8a78";
        };

        tab_bar = {
          background = "#dce0e8";
          inactive_tab_edge = "#ccd0da";
        };

        tab_bar.active_tab = {
          bg_color = "#8839ef";
          fg_color = "#dce0e8";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab = {
          bg_color = "#e6e9ef";
          fg_color = "#4c4f69";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab_hover = {
          bg_color = "#eff1f5";
          fg_color = "#4c4f69";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab = {
          bg_color = "#ccd0da";
          fg_color = "#4c4f69";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab_hover = {
          bg_color = "#bcc0cc";
          fg_color = "#4c4f69";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };
      };

      # ref: https://github.com/catppuccin/wezterm/blob/main/dist/catppuccin-frappe.toml
      catpuccin-frappe = {
        ansi = [ "#51576d" "#e78284" "#a6d189" "#e5c890" "#8caaee" "#f4b8e4" "#81c8be" "#b5bfe2" ];
        background = "#303446";
        brights = [ "#626880" "#e78284" "#a6d189" "#e5c890" "#8caaee" "#f4b8e4" "#81c8be" "#a5adce" ];
        compose_cursor = "#eebebe";
        cursor_bg = "#f2d5cf";
        cursor_border = "#f2d5cf";
        cursor_fg = "#232634";
        foreground = "#c6d0f5";
        scrollbar_thumb = "#626880";
        selection_bg = "#626880";
        selection_fg = "#c6d0f5";
        split = "#737994";
        visual_bell = "#414559";

        indexed = {
          "16" = "#ef9f76";
          "17" = "#f2d5cf";
        };

        tab_bar = {
          background = "#232634";
          inactive_tab_edge = "#414559";
        };

        tab_bar.active_tab = {
          bg_color = "#ca9ee6";
          fg_color = "#232634";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab = {
          bg_color = "#292c3c";
          fg_color = "#c6d0f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.inactive_tab_hover = {
          bg_color = "#303446";
          fg_color = "#c6d0f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab = {
          bg_color = "#414559";
          fg_color = "#c6d0f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };

        tab_bar.new_tab_hover = {
          bg_color = "#51576d";
          fg_color = "#c6d0f5";
          intensity = "Normal";
          italic = false;
          strikethrough = false;
          underline = "None";
        };
      };
    };

    extraConfig = ''
      local wezterm = require "wezterm"

      -- wezterm.gui is not available to the mux server, so take care to
      -- do something reasonable when this config is evaluated by the mux
      function get_appearance()
        if wezterm.gui then
          return wezterm.gui.get_appearance()
        end
        return "Dark"
      end

      function scheme_for_appearance(appearance)
        if appearance:find "Dark" then
          return "catpuccin-mocha"
        else
          return "catpuccin-latte"
        end
      end

      local config = wezterm.config_builder()

      config.front_end = "WebGpu"
      config.font = wezterm.font("0xProto Nerd Font", { weight = 'Regular', italic = false })
      config.font_size = 12.0
      config.color_scheme = scheme_for_appearance(get_appearance())
      config.keys = {
        {
          key = 'n',
          mods = 'SHIFT|CTRL',
          action = wezterm.action.ToggleFullScreen,
        },
      }

      return config
    '';
  };
}
