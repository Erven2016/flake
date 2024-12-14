{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf;
in
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  config =
    mkIf ((config.boot.bootspec.enable == true) && (config.boot.initrd.systemd.enable == true))
      {
        environment.systemPackages = with pkgs; [
          # For debugging and troubleshooting Secure Boot.
          sbctl
        ];

        # Lanzaboote currently replaces the systemd-boot module.
        # This setting is usually set to true in configuration.nix
        # generated at installation time. So we force it to false
        # for now.
        boot.loader.systemd-boot.enable = lib.mkForce false;

        boot.lanzaboote = {
          enable = true;
          pkiBundle = "/etc/secureboot";
        };
      };
}
