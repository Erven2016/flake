{
  pkgs,
  lib,
  config,
  users,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkForce
    mkDefault
    ;

  # load current shell from user configuration
  shell = users."${config.home.username}".shell;

  cfg = config.home.programs.zsh;
in
{
  options.home.programs.zsh = {
    enable = mkEnableOption "zsh shell configuration in home-manager" // {
      default = if (shell.pname == "zsh") then true else false;
      readOnly = true;
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = mkForce true;
      package = shell;

      autosuggestion = {
        enable = mkDefault true;
        strategy = mkDefault [ "completion" ];
      };

      oh-my-zsh = {
        enable = mkDefault true;
        plugins = mkDefault [
          "sudo"
          "git"
        ];
        theme = mkDefault "gentoo";
      };
    };

    programs.fzf = {
      enable = mkDefault true;
      enableZshIntegration = mkDefault true;
    };

    home.packages = with pkgs; [
      zsh-autosuggestions
      zsh-autocomplete
      zsh-autopair
    ];
  };
}
