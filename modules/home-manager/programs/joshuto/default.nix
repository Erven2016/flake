{
  lib,
  # pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.home.programs.joshuto;
in
{
  options.home.programs.joshuto = {
    enable = mkEnableOption "joshuto in home manager";
    enableZshIntegration = mkEnableOption "joshuto integration for zsh";
  };
  config = {
    home.programs.joshuto.enableZshIntegration = config.home.programs.zsh.enableJoshuto;

    programs.joshuto = {
      enable = mkIf (cfg.enable || config.home.programs.zsh.enableJoshuto) true;
    };
  };
}
