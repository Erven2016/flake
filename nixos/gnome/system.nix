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
  imports = [ ../shared_modules/input_methods/ibus.nix ];

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

    # environment.gnome.excludePackages = with pkgs; [ ];

    environment.systemPackages = mkMerge [
      (with pkgs; [
        gnome-tweaks
        gnome-power-manager
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
