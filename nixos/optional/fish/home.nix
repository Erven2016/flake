{
  config,
  users,
  lib,
  ...
}:
let
  inherit (lib)
    mkIf
    mkEnableOption
    mkForce
    mkDefault
    ;

  # load current shell from user configuration
  shell = users."${config.home.username}".shell;

  cfg = config.home.programs.fish;
in
{
  options.home.programs.fish = {
    enable = mkEnableOption "fish shell configuration in home-manager" // {
      default = if (shell.pname == "fish") then true else false;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = mkForce true;
      package = shell;
    };

    programs.fzf = {
      enable = mkDefault true;
    };
  };
}
