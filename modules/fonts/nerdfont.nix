{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkOption types mkMerge;

  coreNerdFonts = [
    "FiraCode"
    "IBMPlexMono"
  ];

  cfg = config.system.fonts;
in
{
  options.system.fonts = {

    extraNerdFonts = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

  };
  config = {
    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = (coreNerdFonts) ++ (cfg.extraNerdFonts); })
    ];
  };
}
