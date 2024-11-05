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

    allowTerminalReplaceConsole = mkEnableOption "replacing gnome-console with gnome-terminal";
  };

  config = mkIf (config.system.desktop.preferDesktop == "gnome") {

    # enable xorg display server
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = config.system.desktop.enableWayland;
      desktopManager.gnome.enable = true;
    };

    # # excludePackages
    # environment.gnome.excludePackages =
    #   (with pkgs; [
    #     gnome-tour # 使用向导
    #     gnome-console # replaced with gnome-terminal
    #     gedit # text editor
    #   ])
    #   ++ (with pkgs.gnome; [
    #     # 一些小游戏
    #     tali # poker game
    #     iagno # go game
    #     hitori # sudoku game
    #     atomix # puzzle game

    #     # I don't like it because it will stuck sometime when installing something!!!
    #     # Using `flatpak` command to manage flatpak applications in terminal is better
    #     gnome-software
    #   ]);

    environment.gnome.excludePackages = cfg.excludePackages;

    # services.gnome.core-utilities.enable = cfg.enableGnomeApps;

    environment.systemPackages = mkMerge [
      (with pkgs.gnome; [
        gnome-tweaks
        gnome-terminal
      ])

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
