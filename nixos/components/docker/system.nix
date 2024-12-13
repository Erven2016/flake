{
  current,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkIf;

  cfg = current.components.docker;
in
{
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;

      storageDriver = mkIf (config.fileSystems."/".fsType == "btrfs") "btrfs";

      # rootless = {
      #   enable = true;
      # };
    };
  };
}
