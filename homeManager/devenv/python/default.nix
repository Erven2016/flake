{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkOption
    types
    mkMerge
    mkIf
    ;

  # Default python version
  # It is recommanded to choose a python version which is stable
  # and has a large amount of pythonModules/packages in nixpkgs.
  defaultPythonPackage = pkgs.python312Full;
  defaultPipPackakge = pkgs.python312Packages.pip;

  cfg = config.home.devenv.python;
in
{
  options.home.devenv.python = {
    enable = mkEnableOption "Python development environment";

    package = mkOption {
      type = types.package;
      default = defaultPythonPackage;
    };

    pip = mkOption {
      type = types.package;
      default = defaultPipPackakge;
    };
  };

  config = mkIf (cfg.enable) {
    home.packages = mkMerge [
      [
        cfg.package
        cfg.pip
        pkgs.pipx
      ]
    ];
  };
}
