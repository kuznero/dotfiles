{ lib, pkgs, ... }:

{
  home.file = {
    ".local/share/zsh-custom/themes" = {
      source = ./dotfiles/zsh-custom/themes;
      recursive = true;
      force = true;
    };
    ".config/ghostty/themes" = {
      source = ./dotfiles/config/ghostty/themes;
      recursive = true;
      force = true;
    };
    ".config/k9s" = {
      source = ./dotfiles/config/k9s;
      recursive = true;
      force = true;
    };
    ".config/opencode/opencode.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/config.json";
      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
        };
      };
      plugin = [ "opencode-anthropic-auth@latest" ];
      provider = {
        ollama = {
          npm = "@ai-sdk/openai-compatible";
          name = "Ollama (local)";
          options = {
            baseURL = "http://localhost:11434/v1";
          };
          models = {
            "gemma4:latest" = { };
            "gemma4:e2b" = { };
          };
        };
        llama-cpp = {
          npm = "@ai-sdk/openai-compatible";
          name = "llama-server (local)";
          options = {
            baseURL = "http://127.0.0.1:8080/v1";
          };
          models = {
            gemma-4-26b-a4b-it = {
              name = "Gemma 4 26B-A4B-it (local)";
              limit = {
                context = 256000;
                output = 65536;
              };
            };
          };
        };
      };
    };
    "Library/Application Support/k9s" = {
      source = ./dotfiles/config/k9s;
      recursive = true;
      force = true;
    };
    ".config/mc" = {
      source = ./dotfiles/config/mc;
      recursive = true;
      force = true;
    };
    ".config/yazi" = {
      source = ./dotfiles/config/yazi;
      recursive = true;
      force = true;
    };
  };

  home.activation.opencodeAuth = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    auth_dir="$HOME/.local/share/opencode"
    auth_file="$auth_dir/auth.json"
    tmp_file="$auth_dir/auth.json.tmp"

    mkdir -p "$auth_dir"

    if [ ! -e "$auth_file" ]; then
      cat > "$auth_file" <<'EOF'
    {"ollama":{"type":"api","key":"ollama"}}
    EOF
      exit 0
    fi

    if ! ${pkgs.jq}/bin/jq empty "$auth_file" >/dev/null 2>&1; then
      echo "warning: $auth_file is not valid JSON; leaving it unchanged" >&2
      exit 0
    fi

    ${pkgs.jq}/bin/jq '
      if has("ollama") then
        .
      else
        . + {"ollama": {"type": "api", "key": "ollama"}}
      end
    ' "$auth_file" > "$tmp_file"

    mv "$tmp_file" "$auth_file"
  '';
}
