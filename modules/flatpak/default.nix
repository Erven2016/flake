{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkEnableOption
    mkIf
    mkMerge
    mkForce
    ;

  cfg = config.system.flatpak;
in
{
  imports = [ ];
  options.system.flatpak = {
    enable = mkEnableOption "flatpak for system";
    autoEnable = mkEnableOption "automatically deploying flatpak";
    enableDevTools = mkEnableOption "installing flatpak-builder, etc.";
  };
  config = {
    # 写死，只允许通过封装选项开启，即 config.system.flatpak.enable
    services.flatpak.enable = cfg.enable;
    system.flatpak.enableDevTools = false; # 默认不安装 flatpak 打包工具

    # Flatpak XDG portal 依赖
    xdg.portal.enable = mkForce true;

    environment.systemPackages = mkMerge [
      # 安装 Flatpak 开发所需的包
      (mkIf cfg.enableDevTools (
        with pkgs;
        [
          unstable.flatpak-builder # flatpak dev
          appstream # 有时候打包会用到
        ]
      ))
    ];

    # 修复 Flatpak 应用不能发现系统环境中的字体
    # todo: 按需启用对应的 system-icons
    system.fsPackages = [ pkgs.bindfs ];
    fileSystems =
      let
        mkRoSymBind = path: {
          device = path;
          fsType = "fuse.bindfs";
          options = [
            "ro"
            "resolve-symlinks"
            "x-gvfs-hide"
          ];
        };
        aggregatedIcons = pkgs.buildEnv {
          name = "system-icons";
          paths = with pkgs; [
            #libsForQt5.breeze-qt5  # for Plasma
            gnome.gnome-themes-extra # for Gnome
          ];
          pathsToLink = [ "/share/icons" ];
        };
        aggregatedFonts = pkgs.buildEnv {
          name = "system-fonts";
          paths = config.fonts.packages;
          pathsToLink = [ "/share/fonts" ];
        };
      in
      {
        "/usr/share/icons" = mkRoSymBind "${aggregatedIcons}/share/icons";
        "/usr/local/share/fonts" = mkRoSymBind "${aggregatedFonts}/share/fonts";
      };
  };
}
