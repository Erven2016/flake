{ current, lib, ... }:
let
  inherit (lib) mkIf mkDefault;

in
{
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
      systemd-boot = mkIf (current.bootloader == "systemd-boot") { enable = true; };
    };
  };
}
