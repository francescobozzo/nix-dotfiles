{ pkgs-unstable, pkgs, ... }:

let
  ollamaPort = 11434;
  openwebuiPort = 9090;
in
{
  services.ollama = {
    enable = true;
    port = ollamaPort;
    host = "0.0.0.0";
    openFirewall = true;
    package = pkgs.ollama;
    acceleration = "rocm";
    rocmOverrideGfx = "11.5.1";
    loadModels = [
      # "qwen3-coder:30b"  # tool calls not working
      "qwen3:30b"
    ];
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      # OLLAMA_CONTEXT_LENGTH = "256000"; # max supported by qwen3-coder:30b
      OLLAMA_CONTEXT_LENGTH = "64000";
      # OLLAMA_KEEP_ALIVE = "-1"; # keep the model loaded
    };
  };

  services.open-webui = {
    enable = true;
    port = openwebuiPort;
    host = "0.0.0.0";
    openFirewall = true;
    environment = {
      OLLAMA_BASE_URL = "http://127.0.0.1:${toString ollamaPort}";
    };
    package = pkgs-unstable.open-webui;
  };
}
