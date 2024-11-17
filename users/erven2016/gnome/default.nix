# Home-Manager Submodule For Gnome
{ pkgs, lib, ... }:
let
  inherit (lib) mkMerge;
in
{
  config = {
    home.packages = mkMerge [
      (with pkgs.gnomeExtensions; [
        gnome-40-ui-improvements
        alphabetical-app-grid
        luminus-shell-y
        blur-my-shell
        wtmb-window-thumbnails
      ])
    ];
  };
}
