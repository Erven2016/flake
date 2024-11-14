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
  config = mkIf (current.preferDesktop == "gnome") {
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
