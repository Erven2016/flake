{
  lib,
  config,
  inputs,
  system,
  ...
}:
let
  inherit (lib) mkEnableOption mkDefault mkIf;

  cfg = config.system.bootloader;
in
{
  options.system.bootloader = {
    enable = mkEnableOption "";
  };
  config = {
    system.bootloader = {
      enable = mkDefault true;
    };

    boot.loader = mkIf cfg.enable {
      efi = {
        canTouchEfiVariables = mkDefault true;
        efiSysMountPoint = mkDefault "/boot"; # ← use the same mount point here.
      };
      grub = {
        enable = mkDefault true;
        efiSupport = mkDefault true;
        #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
        device = mkDefault "nodev";
        theme = mkDefault inputs.distro-grub-themes.packages.${system}.nixos-grub-theme;
      };
    };
  };
}
