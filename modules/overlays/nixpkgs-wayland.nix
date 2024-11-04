{ lib, config, ... }:
let
  inherit (lib)
    mkDefault
    mkIf
    mkOption
    types
    ;
in
{
  options = {
    custom-modules.enable-google-chrome-wayland = mkOption {
      type = types.bool;
      default = false;
      example = true;
      description = "Enable wayland features on google-chrome.";
    };
  };
  config = {
    nixpkgs.overlays = [
      (self: super: {
        google-chrome = mkIf config.custom-modules.enable-google-chrome-wayland (
          super.google-chrome.override {
            commandLineArgs = [
              "--ozone-platform-hint=auto"
              "--enable-features=WaylandWindowDecorations"
              "--enable-features=TouchpadOverscrollHistoryNavigation"
              "--gtk-version=4"
            ];
          }
        );
      })
    ];
  };
}
