{
  lib,
  config,
  pkgs,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkOption
    mkEnableOption
    types
    mkMerge
    mkIf
    ;

  # 默认安装的 nodejs 版本
  DEFAULT_NODEJS_PACKAGES = pkgs.nodejs_22;
  BUILTIN_NPM_PACKAGES = with pkgs; [ nodePackages_latest.nrm ];

  cfg = config.system.nodejs;
in
{
  options.system.nodejs = {
    enable = mkEnableOption "nodejs in system";

    extraGlobalPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      example = [
        pkgs.nodePackages_latest.nrm
        pkgs.nodePackages.yarn
      ];
      description = "extra npm global packages";
    };
  };
  config = mkIf cfg.enable {
    environment.systemPackages = mkMerge [
      ([ DEFAULT_NODEJS_PACKAGES ]) # 安装 nodejs
      (BUILTIN_NPM_PACKAGES) # 安装推荐的 npm 全局包
      (cfg.extraGlobalPackages) # 安装用户自定义的 npm 全局包
    ];
  };
}
