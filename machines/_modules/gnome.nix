{ pkgs, ... }:
{
  config = {
    # Gnome
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.systemPackages = with pkgs; [
      # Gnome extensions
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
      gnomeExtensions.caffeine
      gnomeExtensions.gsconnect
      gnomeExtensions.removable-drive-menu
      gnomeExtensions.vitals
      gnomeExtensions.dash-to-dock
      gnomeExtensions.just-perfection
    ];
  };
}
