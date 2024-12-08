{
  pkgs,
  lib,
  config,
  ...
}:
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

      shellAliases = {
        "ll" = "lsd -lh";
        "la" = "lsd -lah";
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

      lsd
    ];
  };
}
