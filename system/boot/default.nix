{
  current,
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkDefault
    mkOption
    types
    ;

in
{

  imports = [ ./plymouth.nix ];

  config = {
    boot.loader = {
      efi = mkIf (current.isEFI) {
        canTouchEfiVariables = mkDefault true;
        efiSysMountPoint = current.efiSysMountPoint;
      };
      grub = mkIf (current.bootloader == "grub") {
        efiSupport = current.isEFI;
        device = current.grubDevice;
      };
      systemd-boot = mkIf (current.bootloader == "systemd-boot") {
        enable = true;
        memtest86.enable = mkDefault true;
        netbootxyz.enable = mkDefault true;
        consoleMode = mkDefault "keep";
        configurationLimit = current.bootRollbackConfigurationsLimit;
      };
    };
  };
}
