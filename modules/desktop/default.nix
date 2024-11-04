{ lib, config, ... }:
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
  imports = [
    # import gnome desktop configuration
    ./gnome
  ];

  options.system.desktop = {
    enable = mkEnableOption "desktop";
    enableWayland = mkEnableOption "wayland compositor";
    preferDesktop = mkOption {
      type = types.str;
      default = "gnome";
    };
  };

  config = {
    system.desktop.enableWayland = mkDefault true;
  };
}
