{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib) mkEnableOption;
  cfg = config.system.desktop.gnome;
in
{
  options = {

  };

  config = {
    # enable xorg display server
    services.xserver = {
      enable = true;
      displayManager.gdm.enable = true;
      displayManager.gdm.wayland = config.system.desktop.enableWayland;
      desktopManager.gnome.enable = true;
    };

    # excludePackages
    environment.gnome.excludePackages =
      (with pkgs; [
        gnome-tour # 使用向导
        gnome-console # replaced with gnome-terminal
        gedit # text editor
      ])
      ++ (with pkgs.gnome; [
        # 一些小游戏
        tali # poker game
        iagno # go game
        hitori # sudoku game
        atomix # puzzle game

        # I don't like it because it will stuck sometime when installing something!!!
        # Using `flatpak` command to manage flatpak applications in terminal is better
        gnome-software
      ]);

    # services.gnome.core-utilities.enable = false;

    environment.systemPackages = with pkgs; [
      gnome.gnome-tweaks
      gnome.gnome-terminal
      gnomeExtensions.appindicator
      gnomeExtensions.auto-activities
      gnomeExtensions.gnome-40-ui-improvements
      gnomeExtensions.caffeine
      gnomeExtensions.alphabetical-app-grid
      # gnomeExtensions.just-perfection
      gnomeExtensions.luminus-shell-y
      gnomeExtensions.blur-my-shell
      unstable.gnomeExtensions.tiling-shell
      gnomeExtensions.wtmb-window-thumbnails
    ];

    services.udev.packages = with pkgs; [ gnome.gnome-settings-daemon ];
  };
}
