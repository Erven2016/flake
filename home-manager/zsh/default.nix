{ lib, config, ... }:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkForce
    mkDefault
    ;

  cfg = config.home.programs.zsh;
in
{
  options.home.programs.zsh = {
    enable = mkEnableOption "zsh in home manager" // {
      default = true;
    };
  };

  config = mkIf cfg.enable {
    programs.zsh = {
      enable = mkForce true;
      autosuggestion.enable = mkDefault true;

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
  };
}
