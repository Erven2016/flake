{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
in
{
  options = { };
  config = {
    programs.helix = {
      enable = true;
      defaultEditor = true;

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
          auto-format = false;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
      ];

      extraPackages = with pkgs; [
        nil
        nixfmt-rfc-style
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
