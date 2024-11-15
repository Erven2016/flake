{
  current,
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkIf mkOption types;

  cfg = config.system.boot;
in
{
  options.system.boot = {
    plymouth = {
      enable = mkOption {
        type = types.bool;
        example = false;
        default = if ((current.hasTag "desktop") || (current.hasTag "laptop")) then true else false;
      };

      theme = mkOption {
        type = types.str;
        description = "The plymouth theme which to be installed.";
        example = "rings";
        default = "lone";
      };
    };
  };

  config = {
    boot = {
      plymouth = mkIf (cfg.plymouth.enable) rec {
        enable = true;
        theme = cfg.plymouth.theme;
        themePackages = with pkgs; [
          (adi1090x-plymouth-themes.override { selected_themes = [ theme ]; })
        ];
      };

      consoleLogLevel = 0;
      initrd.verbose = false;

      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "loglevel=3"
        "rd.systemd.show_status=false"
        "rd.udev.log_level=3"
        "udev.log_priority=3"
      ];

      loader.timeout = 0;
    };
  };
}
