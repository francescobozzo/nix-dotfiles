{ config, ... }:
{
  # TODO: add on failure notification
  services.restic.backups = {
    backblaze = {
      user = "root";
      initialize = true;
      environmentFile = config.sops.secrets."backblaze/environment".path;
      repositoryFile = config.sops.secrets."backblaze/repository".path;
      passwordFile = config.sops.secrets."backblaze/password".path;
      createWrapper = true;
      extraBackupArgs = [
        "--compression max"
      ];
      exclude = [
        "**/*.log"
        "**/log/**"
        "**/cache/**"
        "**/.cache/**"
        "**/garth_session"
        "**/GarminConnectConfig.json"
      ];
      paths = [
        config.services.home-assistant.configDir
        "${config.services.open-webui.stateDir}/data"
        "${config.services.traefik.dataDir}/acme.json"
        config.services.uptime-kuma.settings.DATA_DIR
      ];
      pruneOpts = [
        "--keep-last 30" # 30 days
      ];
      timerConfig = {
        OnCalendar = "04:00";
        Persistent = true;
      };
    };
  };
}
