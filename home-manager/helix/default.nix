{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib)
    mkDefault
    mkEnableOption
    mkMerge
    mkIf
    mkOption
    types
    ;

  cfg = config.home.programs.helix;
in
{
  options.home.programs.helix = {
    enable = mkEnableOption "helix editor" // {
      default = true;
    };
  };

  config = {
    programs.helix = {
      enable = cfg.enable;
      defaultEditor = mkDefault true;

      settings = {
        theme = mkDefault "transparent-dark";
        editor = {
          mouse = mkDefault false;
          cursorline = mkDefault true;
          auto-format = mkDefault false;
          color-modes = mkDefault true;
          default-line-ending = mkDefault "lf";
          popup-border = mkDefault "all";

          indent-guides = {
            render = mkDefault true;
            character = mkDefault "╎";
            skip-levels = mkDefault 1;
          };

          lsp = {
            enable = mkDefault true;
            display-messages = mkDefault true;
          };

          cursor-shape = {
            normal = mkDefault "block";
            insert = mkDefault "bar";
            select = mkDefault "underline";
          };
        };

        keys.normal = {
          space.i = mkDefault ":format";
        };
      };

      languages.language = [
        {
          name = "nix";
          auto-format = mkDefault false;
          formatter.command = mkDefault "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
      ];

      extraPackages = mkMerge [
        (with pkgs; [
          nil
          nixfmt-rfc-style
        ])
      ];
    };

    xdg.configFile."helix/themes/transparent-dark.toml" = {
      text = builtins.readFile ./config/transparent-dark.toml;
    };

    xdg.configFile."helix/themes/transparent-light.toml" = {
      text = builtins.readFile ./config/transparent-light.toml;
    };
  };
}
