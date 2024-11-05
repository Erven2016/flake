{
  lib,
  config,
  ...
}:
let
  inherit (lib)
    mkIf
    mkDefault
    mkEnableOption
    mkOption
    types
    ;

  cfg = config.system.desktop;
in
{
  imports = [ ./gnome ];

  options.system.desktop = {
    enable = mkEnableOption "desktop environment";
    enableWayland = mkEnableOption "wayland compositor";
    preferDesktop = mkOption {
      type = types.str;
      default = "gnome";
    };
  };

  config = {
    # Enable wayland defaultly
    system.desktop.enableWayland = mkDefault true;
  };
}
