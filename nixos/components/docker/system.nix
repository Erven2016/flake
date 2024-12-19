{ current, lib, ... }:
let
  inherit (lib) mkIf;

  cfg = current.components.docker;
in
{
  config = mkIf cfg.enable {
    virtualisation.docker = {
      enable = true;

      storageDriver = mkIf (current.kits.hasTag "btrfs") "btrfs";

      # rootless = {
      #   enable = true;
      # };
    };
  };
}
