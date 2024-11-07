{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    mkIf
    mkMerge
    types
    ;
  cfg = config.system.desktop.gnome;
in
{
  options.system.desktop.gnome = {
    extraExtensions = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = [
        pkgs.gnomeExtensions.appindicator
        pkgs.gnomeExtensions.auto-activities
      ];
      description = "install extra extension for gnome";
    };
    enableGnomeApps = mkEnableOption "disabling core utils of gnome" // {
      default = true;
    };
    includePackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = [
        pkgs.gnome-tour
        pkgs.gnome-console
      ];
    };
    excludePackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = [
        pkgs.gnome-tour
        pkgs.gnome-console
      ];
    };

    enableGnomeTerminal = mkEnableOption "replacing gnome-console with gnome-terminal";
  };

  config = mkIf (config.system.desktop.preferDesktop == "gnome") {

    # enable xorg display server
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = config.system.desktop.enableWayland;
      desktopManager.gnome.enable = true;
    };

    # environment.gnome.excludePackages = cfg.excludePackages;
    environment.gnome.excludePackages = mkMerge [
      (cfg.excludePackages)
      (mkIf cfg.enableGnomeTerminal [ pkgs.gnome-console ])
    ];

    services.gnome.core-utilities.enable = cfg.enableGnomeApps;

    environment.systemPackages = mkMerge [
      (with pkgs.gnome; [ gnome-tweaks ])

      (mkIf (cfg.enableGnomeTerminal) [ pkgs.gnome.gnome-terminal ])

      (cfg.includePackages)

      # Default extensions
      (with pkgs.gnomeExtensions; [
        appindicator
        caffeine
      ])

      # extra extension which added by users
      (cfg.extraExtensions)

    ];

    services.udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
  };
}
