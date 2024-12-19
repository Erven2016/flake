{ lib, current, ... }:
let
  inherit (lib) mkIf;

  isPipewireEnabled = if (current.sound.preferBackend == "pipewire") then true else false;
in
{
  config = mkIf (current.sound.enable) {
    services.pipewire = {
      enable = isPipewireEnabled;

      # Alsa
      alsa.enable = (current.sound.pipewire.enableAlsa);
      alsa.support32Bit = (current.sound.pipewire.enableAlsa32BitSupport);
      # PulseAudio
      pulse.enable = (current.sound.pipewire.enablePulseaudio);
      # Jack
      jack.enable = (current.sound.pipewire.enableJack);
    };

    # rtkit is recommanded to install with pipewire.
    security.rtkit.enable = isPipewireEnabled;
  };
}
