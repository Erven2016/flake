{
  lib,
  inputs,
  pkgs,
  current,
  ...
}:
{
  imports = [ inputs.lanzaboote.nixosModules.lanzaboote ];

  config = {

    environment.systemPackages = [
      # For debugging and troubleshooting Secure Boot.
      pkgs.sbctl
    ];

    # to use TPM-based FDE
    boot.bootspec.enable = true;
    boot.initrd.systemd.enable = true;

    # Lanzaboote currently replaces the systemd-boot module.
    # This setting is usually set to true in configuration.nix
    # generated at installation time. So we force it to false
    # for now.
    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.lanzaboote = {
      enable = true;
      pkiBundle = current.boot.secureboot.pathPkiBundle;
    };
  };

}
