{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.home.devenv;
in
{
  imports = [
    ./nodejs
    ./rust
    ./python
    ./go
  ];

  options.home.devenv.enable = mkEnableOption "devenv";

  config = {
    home.packages = mkIf (cfg.enable) ([ pkgs.unstable.devenv ]);

    # to use cache nix
    nix.extraOptions = mkIf (cfg.enable) ''
      trusted-users = root ${config.home.username}
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };
}
