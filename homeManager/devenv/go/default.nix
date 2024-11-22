{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkEnableOption
    mkIf
    types
    mkMerge
    ;

  cfg = config.home.devenv.go;

  _packges_go =
    if (cfg.enableLatestVersion) then (with pkgs.unstable; [ go ]) else (with pkgs; [ go ]);

  _packges_with_cgo =
    if (cfg.enableLatestVersion) then
      (with pkgs.unstable; [
        libcap
        go
        gcc
      ])
    else
      (with pkgs; [
        libcap
        go
        gcc
      ]);
in
{
  options.home.devenv.go = {
    enable = mkEnableOption "Go development environment";

    enableLatestVersion = mkEnableOption "use go version of nixpkgs-unstable" // {
      default = true;
    };

    enableCgo = mkEnableOption "use cgo" // {
      default = true;
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    home.packages = mkMerge [
      (if (cfg.enableCgo) then _packges_with_cgo else _packges_go)

      (cfg.extraPackages)
    ];
  };
}
