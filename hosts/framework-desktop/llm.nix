{ pkgs-unstable, ... }:
{
  services.ollama = {
    enable = true;
    host = "0.0.0.0";
    package = pkgs-unstable.ollama;
    port = 11434;
    acceleration = "rocm";
    rocmOverrideGfx = "11.5.1";
    loadModels = [ "qwen3-coder:30b" ];
    environmentVariables = {
      OLLAMA_FLASH_ATTENTION = "1";
      OLLAMA_CONTEXT_LENGTH = "256000";
    };
  };

  # Pending resolution: https://github.com/nixos/nixpkgs/issues/461605
  # services.open-webui = {
  #   enable = true;
  #   package = pkgs-unstable.open-webui;
  # };
}
