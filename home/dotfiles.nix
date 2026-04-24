{ ... }:

{
  home.file = {
    ".local/share/zsh-custom/themes" = {
      source = ./dotfiles/zsh-custom/themes;
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
        llama-cpp = {
          npm = "@ai-sdk/openai-compatible";
          name = "llama-server (local)";
          options = { baseURL = "http://127.0.0.1:8080/v1"; };
          models = {
            # alias llms-e4b="llama-server -hf bartowski/google_gemma-4-E4B-it-GGUF:Q4_0 -c 131072 -ngl 99 --reasoning-budget 32768"
            gemma-4-e4b-it-q4 = {
              name = "Gemma 4 E4B-it Q4 (local)";
              id = "bartowski/google_gemma-4-E4B-it-GGUF:Q4_0";
              limit = {
                context = 131072;
                output = 65536;
              };
            };
            # alias llms-e4b="llama-server -hf bartowski/google_gemma-4-E4B-it-GGUF:Q8_0 -c 131072 -ngl 99 --reasoning-budget 32768"
            gemma-4-e4b-it-q8 = {
              name = "Gemma 4 E4B-it Q8 (local)";
              id = "bartowski/google_gemma-4-E4B-it-GGUF:Q8_0";
              limit = {
                context = 131072;
                output = 65536;
              };
            };
            # alias llms-26b="llama-server -hf bartowski/google_gemma-4-26B-A4B-it-GGUF:Q4_0 -c 131072 -ngl 99 --reasoning-budget 32768"
            gemma-4-26b-a4b-it-q4 = {
              name = "Gemma 4 26B-A4B-it Q4 (local)";
              id = "bartowski/google_gemma-4-26B-A4B-it-GGUF:Q4_0";
              limit = {
                context = 131072;
                output = 65536;
              };
            };
            # alias llms-26b="llama-server -hf bartowski/google_gemma-4-26B-A4B-it-GGUF:Q8_0 -c 131072 -ngl 99 --reasoning-budget 32768"
            gemma-4-26b-a4b-it-q8 = {
              name = "Gemma 4 26B-A4B-it Q8 (local)";
              id = "bartowski/google_gemma-4-26B-A4B-it-GGUF:Q8_0";
              limit = {
                context = 131072;
                output = 65536;
              };
            };
            # alias llms-31b="llama-server -hf bartowski/google_gemma-4-31B-it-GGUF:Q4_0 -c 131072 -ngl 99 --reasoning-budget 32768"
            gemma-4-31b-it-q4 = {
              name = "Gemma 4 31B-it Q4 (local)";
              id = "bartowski/google_gemma-4-31B-it-GGUF:Q4_0";
              limit = {
                context = 131072;
                output = 65536;
              };
            };
            # alias llms-31b="llama-server -hf bartowski/google_gemma-4-31B-it-GGUF:Q8_0 -c 131072 -ngl 99 --reasoning-budget 32768"
            gemma-4-31b-it-q8 = {
              name = "Gemma 4 31B-it Q8 (local)";
              id = "bartowski/google_gemma-4-31B-it-GGUF:Q8_0";
              limit = {
                context = 131072;
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
}
