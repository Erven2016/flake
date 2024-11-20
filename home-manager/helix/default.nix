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

    languages = mkOption {
      type = types.listOf types.str;
      default = [
        "nix"
        "bash"
      ];
    };

    hasLanguage = mkOption {
      readOnly = true;
      default = lang: builtins.elem lang cfg.languages;
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
        {
          name = "yaml";
          auto-format = mkDefault false;
          formatter = {
            command = mkDefault "yamlfmt";
            args = mkDefault [ "-" ];
          };
        }
        {
          name = "bash";
          auto-format = false;
          formatter = {
            command = "shfmt";
            args = [
              # The following formatting flags 
              # closely resemble Google's shell 
              # style defined in 
              # https://google.github.io/styleguide/shellguide.html:
              "-i"
              "2"
              "-ci"
              "-bn"
              "-"
            ];
          };
        }
      ];

      extraPackages = mkMerge [
        (mkIf (cfg.hasLanguage "nix") (
          with pkgs;
          [
            nil
            nixfmt-rfc-style
          ]
        ))

        (mkIf (cfg.hasLanguage "rust") (
          with pkgs;
          [
            rustup
          ]
        ))

        (mkIf (cfg.hasLanguage "bash") (
          with pkgs;
          [
            bash-language-server
            shfmt
          ]
        ))

        (mkIf (cfg.hasLanguage "markdown") (
          with pkgs;
          [
            marksman
            markdown-oxide
          ]
        ))

        (mkIf (cfg.hasLanguage "yaml") (
          with pkgs;
          [
            yaml-language-server
            yamlfmt
          ]
        ))

        (mkIf (cfg.hasLanguage "toml") (with pkgs; [ taplo ]))

        (mkIf (cfg.hasLanguage "python") (with pkgs; [ python312Packages.python-lsp-server ]))

        (mkIf ((cfg.hasLanguage "json") || (cfg.hasLanguage "jsonc")) (
          with pkgs;
          [
            nodePackages_latest.vscode-json-languageserver
          ]
        ))

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
