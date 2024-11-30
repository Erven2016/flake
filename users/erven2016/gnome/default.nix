# Home-Manager Submodule For Gnome
{
  pkgs,
  lib,
  current,
  ...
}:
let
  inherit (lib) mkMerge mkIf;
in
{
  imports = [ ./keybinding.nix ];

  config = mkIf (current.desktop == "gnome") {
    home.packages = mkMerge [
      (with pkgs.gnomeExtensions; [
        alphabetical-app-grid
        dock-from-dash
        wtmb-window-thumbnails
        just-perfection
        net-speed-simplified
      ])
    ];
  };

  # dconf.settings = {};
}
