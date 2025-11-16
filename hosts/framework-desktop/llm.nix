{ pkgs-unstable, ... }:

let
  ollamaPort = 11434;
in
{
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs-unstable.ollama;
    port = ollamaPort;
    acceleration = "rocm";
    rocmOverrideGfx = "11.5.1";
    loadModels = [ "qwen3-coder:30b" ];
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      # OLLAMA_CONTEXT_LENGTH = "256000"; # max supported by qwen3-coder:30b
      OLLAMA_CONTEXT_LENGTH = "64000";
      OLLAMA_KEEP_ALIVE = "-1"; # keep the model loaded
    };
  };

  networking.firewall.allowedUDPPorts = [ ollamaPort ];
  networking.firewall.allowedTCPPorts = [ ollamaPort ];

  # Pending resolution: https://github.com/nixos/nixpkgs/issues/461605
  # services.open-webui = {
  #   enable = true;
  #   package = pkgs-unstable.open-webui;
  # };
}
