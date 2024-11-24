{ current, lib, ... }:
let
  inherit (lib) mkIf mkMerge;

  prefix = "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/";

  genPathForRecord = name: [ "/${prefix}${name}/" ];
in
{
  config = mkIf (current.desktop == "gnome") {
    dconf.settings = {
      "org/gnome/settings-daemon/plugins/media-keys".custom-keybindings = mkMerge [
        (genPathForRecord "OpenConsole")
        (genPathForRecord "OpenNautilus")
      ];

      "${prefix}OpenConsole" = {
        name = "Open Console (by HomeManager)";
        binding = "<Super>t";
        command = "kgx";
      };

      "${prefix}OpenNautilus" = {
        name = "Open Nautilus (by HomeManager)";
        binding = "<Super>e";
        command = "nautilus";
      };
    };
  };
}
