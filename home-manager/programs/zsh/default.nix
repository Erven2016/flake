{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkOption
    mkIf
    mkEnableOption
    # types
    mkDefault
    mkMerge
    ;

  cfg = config.home.programs.zsh;
in
{
  options.home.programs.zsh = {
    enable = mkEnableOption "zsh";

    # navi: a commands suggestion
    enableNavi = mkEnableOption "navi integration for zsh";

    # yazi: a file manager
    enableYazi = mkEnableOption "yazi integration for zsh;";

    # joshuto: a file manager
    enableJoshuto = mkEnableOption "joshuto integration for zsh";
  };

  config = {
    # Default values
    home.programs.zsh.enable = mkDefault true;
    home.programs.zsh.enableNavi = mkDefault true;
    home.programs.zsh.enableYazi = mkDefault false;
    home.programs.zsh.enableJoshuto = mkDefault true;

    # Zsh configuration
    programs.zsh = mkIf cfg.enable {
      enable = cfg.enable; # 写死，只能通过 home.programs.zsh.enable 设置
      oh-my-zsh = {
        enable = mkDefault true;
        plugins = mkDefault [
          "sudo"
          "git"
        ];
        theme = mkDefault "mgutz";
      };

      sessionVariables = { };

      shellAliases = mkMerge [
        (mkIf config.home.programs.joshuto.enableZshIntegration { "ff" = "joshuto ."; })
      ];

    };

    # 额外的包
    # home.packages = mkMerge [
    #   (mkIf cfg.enableNavi (with pkgs; [ navi ]))
    #   (mkIf cfg.enableNavi (with pkgs; [ fzf ]))
    # ];
  };
}
