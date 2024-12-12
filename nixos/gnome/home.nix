{ current, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf (current.desktop == "gnome") {
    dconf.settings = {
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };
    };
  };
}
