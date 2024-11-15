{ lib, current, ... }:
let
  inherit (lib) mkIf mkDefault;
in
{
  config = mkIf (current.isDesktopEnabled) {
    services.pipewire = {
      enable = current.sound.enable;

      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
      jack.enable = mkDefault true;
    };

    # rtkit is recommanded to install with pipewire.
    security.rtkit.enable = mkDefault true;
  };
}
