{ lib, config, ... }@args:
let
  inherit (lib) types mkOption mkEnableOption;

  cfg = config;
in
{
  options = {
    hostname = mkOption {
      type = types.str;
      readOnly = true;
      default = args.hostname;
    };

    architecture = mkOption {
      type = types.str;
      default = "x86_64-linux";
    };

    stateVersion = mkOption {
      type = types.str;
      readOnly = true;
      default = (import ../../nixosVersion.nix);
    };

    tags = mkOption {
      type = types.listOf types.str;
      default = [ ];
    };

    hasTag = mkOption {
      readOnly = true;
      default = tag: builtins.elem tag cfg.tags;
    };

    desktop = mkOption {
      type = types.enum [
        "gnome"
        "cosmic"
        null
      ];
      default = null;
    };

    isDesktopEnabled = mkOption {
      type = types.bool;
      readOnly = true;
      default = (cfg.desktop != null);
    };

    i18n = {
      timeZone = mkOption {
        type = types.str;
        default = "Asia/Taipei";
      };
      defaultLocale = mkOption {
        type = types.str;
        default = "en_US.UTF-8";
      };
      supportedLocales = mkOption {
        type = types.listOf types.str;
        default = [ "en_US.UTF-8/UTF-8" ];
      };
    };

    sound.enable = mkEnableOption "sound" // {
      default = true;
    };

    users = mkOption {
      type = types.listOf types.str;
      description = "Users which specified to import from home-manager.";
      default = [ ];
    };

    enableWayland = mkEnableOption "wayland" // {
      default = true;
    };

    allowUnfreePackages = mkEnableOption "unfree packages from nixpkgs" // {
      default = true;
    };

    efiSysMountPoint = mkOption {
      type = types.nullOr types.str;
      default = null;
    };

    grubDevice = mkOption {
      type = types.str;
      default = "nodev";
    };

    isEFI = mkOption {
      type = types.bool;
      readOnly = true;
      default = (cfg.efiSysMountPoint != null);
    };

    bootloader = mkOption {
      type = types.str;
      default = if (cfg.efiSysMountPoint != null) then "systemd-boot" else "grub";
    };

    bootRollbackConfigurationsLimit = mkOption {
      type = types.int;
      default = 20;
    };
  };

  options.boot = {
    enableSecureBoot = mkEnableOption "secure boot by lanzaboote";
  };

  options.powerManagement = {
    hibernate = {
      enable = mkEnableOption "automatical hibernate" // {
        default = true;
      };
      afterSeconds = mkOption {
        type = types.str;
        description = "Automatically hibernate after how many seconds countdown, defaultly it is 3 hours.";
        default = "10800";
      };
    };
  };

  options.components = {
    waydroid.enable = mkEnableOption "waydroid";
    flatpak.enable = mkEnableOption "flatpak for current host";
    kvm = {
      enable = mkEnableOption "kvm for host";
      allowUsers = mkOption {
        type = types.listOf types.str;
        description = lib.literalExpression ''
          Users who allowed to manage kvm.
        '';
        default = [ ];
      };
    };
    docker = {
      enable = mkEnableOption "docker for host";
      allowUsers = mkOption {
        type = types.listOf types.str;
        description = lib.literalExpression ''
          Users who will be imported by home-manager,
          so make true that user dirs are created in root/user/
        '';
        example = [
          "username1"
          "username2"
        ];
        default = [ ];
      };
    };
  };
}
