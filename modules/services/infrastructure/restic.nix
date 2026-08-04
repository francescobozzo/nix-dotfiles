{
  flake.modules.nixos.restic =
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
            "/var/lib/nixos" # state needed to generate stable uids and gids
            "${config.services.traefik.dataDir}/acme.json"
          ]
          ++ (builtins.concatLists (map (service: service.toBackup) config.fb.services));
          pruneOpts = [
            "--keep-last 30" # 30 days
          ];
          timerConfig = {
            OnCalendar = "04:00";
            Persistent = true;
          };
        };
      };
    };
}
