{ pkgs, config, ... }:

let
  # Import catppuccin palettes
  palette = (pkgs.lib.importJSON "${config.catppuccin.sources.palette}/palette.json");

  # Helper to generate FZF color scheme from catppuccin palette
  makeFzfColors = flavor: accent: let
    colors = palette.${flavor}.colors;
    accentColor = colors.${accent}.hex;
  in [
    "--color=bg+:${colors.surface0.hex}"
    "--color=bg:${colors.base.hex}"
    "--color=spinner:${colors.rosewater.hex}"
    "--color=hl:${accentColor}"
    "--color=fg:${colors.text.hex}"
    "--color=header:${accentColor}"
    "--color=info:${accentColor}"
    "--color=pointer:${accentColor}"
    "--color=marker:${accentColor}"
    "--color=fg+:${colors.text.hex}"
    "--color=prompt:${accentColor}"
    "--color=hl+:${accentColor}"
  ];

  latteColors = makeFzfColors "latte" "mauve";
  mochaColors = makeFzfColors "mocha" "mauve";
in
{
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultCommand = "fd --type f";
    defaultOptions = [ "--height 40%" "--border" ];
    fileWidgetCommand = "fd --type f";
    fileWidgetOptions = [ "--preview 'head {}'" ];
    changeDirWidgetCommand = "fd --type d";
    changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
    tmux.enableShellIntegration = true;
    historyWidgetOptions = [ "--sort" "--exact" ];
  };

  # Dynamic FZF colors based on appearance file
  # Use mkOrder 2000 to run after fzf integration (which sets up widgets)
  programs.zsh.initContent = pkgs.lib.mkOrder 2000 ''
    # Function to get FZF colors based on current appearance
    _fzf_catppuccin_colors() {
      local appearance="latte"
      if [ -f ~/.config/appearance ]; then
        appearance=$(cat ~/.config/appearance)
      fi

      if [ "$appearance" = "mocha" ]; then
        echo "${pkgs.lib.concatStringsSep " " mochaColors}"
      else
        echo "${pkgs.lib.concatStringsSep " " latteColors}"
      fi
    }

    # Wrapper function for fzf that reads appearance file on each invocation
    fzf() {
      FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $(_fzf_catppuccin_colors)" command fzf "$@"
    }

    # Wrap fzf widgets to use current appearance
    if (( $+functions[fzf-file-widget] )); then
      _original_fzf_file_widget="''${functions[fzf-file-widget]}"
      fzf-file-widget() {
        FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $(_fzf_catppuccin_colors)" eval "$_original_fzf_file_widget"
      }
    fi

    if (( $+functions[fzf-cd-widget] )); then
      _original_fzf_cd_widget="''${functions[fzf-cd-widget]}"
      fzf-cd-widget() {
        FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $(_fzf_catppuccin_colors)" eval "$_original_fzf_cd_widget"
      }
    fi

    if (( $+functions[fzf-history-widget] )); then
      _original_fzf_history_widget="''${functions[fzf-history-widget]}"
      fzf-history-widget() {
        FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS $(_fzf_catppuccin_colors)" eval "$_original_fzf_history_widget"
      }
    fi
  '';
}
