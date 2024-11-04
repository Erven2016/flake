{ lib, config, ... }:
let

  inherit (lib) mkIf mkEnableOption mkDefault;
  # 如果使用了图形化界面就自动配置声音
  isEnableSound = config.services.xserver.enable;

  cfg = config.system.sound;
in
{
  options.system.sound = {
    enable = mkEnableOption "sound for system";

    # 不可以同时使用多个声音后端，会报错。
    preferPipewire = mkEnableOption "pipewire for sound system";
    preferPulseaudio = mkEnableOption "pulseaudio for sound system";
  };

  config = mkIf isEnableSound {
    # 默认使用 Pipewire 后端
    system.sound.preferPipewire = mkDefault true;
    # 默认禁用 Pulseaudio 后端
    system.sound.preferPulseaudio = mkDefault false;

    # pipewire 配置
    services.pipewire = mkIf cfg.preferPipewire {
      enable = true;
      alsa.enable = mkDefault true;
      alsa.support32Bit = mkDefault true;
      pulse.enable = mkDefault true;
      jack.enable = mkDefault false;
    };

    # rtkit 可选择性安装但是推荐安装
    security.rtkit.enable = mkDefault cfg.preferPipewire;

    hardware.pulseaudio.enable = cfg.preferPulseaudio;

  };
}
