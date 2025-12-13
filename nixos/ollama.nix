{ inputs, lib, pkgs, ... }:

{
  services.ollama = {
    enable = true;
    package = pkgs.ollama;
    host = "0.0.0.0";
    environmentVariables = {
      OLLAMA_NUM_PARALLEL = "4";
      OLLAMA_MAX_LOADED_MODELS = "2";
    };
    loadModels = [ "phi3:mini" ];
  };

  services.open-webui = {
    enable = false;
    package = pkgs.open-webui;
    host = "0.0.0.0";
    port = 11436;
    openFirewall = false;
    environment = {
      # OLLAMA_BASE_URLS is a ";"-separated list. If you have multiple
      # here, open webui will be able to load-balance them. Note that open
      # webui has a backend, which means that the URL here is meant for
      # the backend, not the frontend (e.g. user's browser).
      OLLAMA_BASE_URLS = lib.mkDefault "http://127.0.0.1:11434";
      WEBUI_AUTH = "False";
      ANONYMIZED_TELEMETRY = "False";
      DO_NOT_TRACK = "True";
    };
  };
}
