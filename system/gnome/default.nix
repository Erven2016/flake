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
      enable = true;
      type = "ibus";
      ibus.engines = mkMerge [
        (mkIf (
          (builtins.elem "zh_CN.UTF-8/UTF-8" current.i18n.supportedLocales)
          || (builtins.elem "zh_TW.UTF-8/UTF-8" current.i18n.supportedLocales)
        ) [ pkgs.ibus-engines.libpinyin ])
      ];
    };

    # environment.gnome.excludePackages = with pkgs; [ ];

    environment.systemPackages = mkMerge [
      (with pkgs; [
        gnome-tweaks
        gnome-power-manager

        resources
      ])

      # Default extensions
      (with pkgs.gnomeExtensions; [
        appindicator
        caffeine
        auto-power-profile
        customize-ibus
        auto-activities
      ])
    ];

    # Appindicator required
    services.udev.packages = [ pkgs.gnome-settings-daemon ];
  };
}
