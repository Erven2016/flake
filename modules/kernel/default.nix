{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkDefault;

  cfg = config.system.kernel;
in
{
  options.system.kernel = {
    enableLatestKernel = mkEnableOption "using latest kernel of Linux";

    extraModules = {
      enableAppleKeyboardFnMode = mkEnableOption "apple keyboard fn mode";
    };
  };

  config = {
    system.kernel.extraModules.enableAppleKeyboardFnMode = mkDefault true;

    # using latest linux kernel
    boot.kernelPackages = mkIf (cfg.enableLatestKernel) pkgs.linuxPackages_latest;

    # To fix that some keyboards' fn keys are not working
    boot.extraModprobeConfig = mkIf cfg.extraModules.enableAppleKeyboardFnMode ''
      options hid_apple fnmode=0
    '';
  };
}
