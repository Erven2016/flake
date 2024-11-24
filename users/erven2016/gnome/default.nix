# Home-Manager Submodule For Gnome
{ pkgs, lib, ... }:
let
  inherit (lib) mkMerge;
in
{
  config = {
    home.packages = mkMerge [
      (with pkgs.gnomeExtensions; [
        alphabetical-app-grid
        luminus-shell-y
        blur-my-shell
        wtmb-window-thumbnails
        dash-to-panel
        just-perfection
      ])
    ];
  };
}
