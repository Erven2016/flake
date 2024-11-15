{
  lib,
  pkgs,
  current,
  ...
}:
let
  inherit (lib) mkIf mkMerge;
in
{
  config = mkIf (current.desktop == "gnome") {
    services.xserver = {
      enable = true;
      displayManager = {
        gdm = {
          enable = true;
          wayland = current.enableWayland;
        };
      };
      desktopManager.gnome.enable = true;
    };

    i18n.inputMethod = {
      enabled = "ibus";
      ibus.engines = mkMerge [
        (mkIf (
          (builtins.elem "zh_CN.UTF-8/UTF-8" current.i18n.supportedLocales)
          || (builtins.elem "zh_TW.UTF-8/UTF-8" current.i18n.supportedLocales)
        ) [ pkgs.ibus-engines.libpinyin ])
      ];
    };

    environment.systemPackages = mkMerge [
      [
        pkgs.gnome.gnome-tweaks
        pkgs.gnome.gnome-terminal
      ]

      (with pkgs.gnomeExtensions; [
        appindicator
        caffeine
      ])
    ];

    # Appindicator required
    services.udev.packages = [ pkgs.gnome.gnome-settings-daemon ];
  };
}
