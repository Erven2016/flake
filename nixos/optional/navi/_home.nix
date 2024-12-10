{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  cfg = config.home.programs.navi;
in
{
  options.home.programs.navi = {
    enable = mkEnableOption "navi" // {
      default = true;
    };
  };
  config = {
    programs.navi = mkIf cfg.enable {
      enable = true;
    };
  };
}
