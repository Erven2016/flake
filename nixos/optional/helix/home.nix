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
    # mkIf
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

          statusline = {
            left = mkDefault [
              "mode"
              "spinner"
              "file-name"
              "read-only-indicator"
              "file-modification-indicator"
            ];
            right = mkDefault [
              "diagnostics"
              "selections"
              "register"
              "file-encoding"
              "separator"
              "position"
              "position-percentage"
            ];
          };
        };

        keys.normal = {
          space.i = mkDefault ":format";
        };
      };

      languages.language = [
        # @@@
        # nix
        # @@@
        {
          name = "nix";
          auto-format = mkDefault false;
          formatter = {
            command = mkDefault "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
            args = mkDefault [ "-s" ];
          };
        }
        # @@@@
        # yaml
        # @@@@
        {
          name = "yaml";
          auto-format = mkDefault false;
          formatter = {
            command = mkDefault "yamlfmt";
            args = mkDefault [ "-" ];
          };
        }
        # @@@@
        # bash
        # @@@@
        {
          name = "bash";
          auto-format = mkDefault false;
          formatter = {
            command = mkDefault "shfmt";
            args = mkDefault [
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

      # Installing LSPs or Formatters of some languages for Helix
      extraPackages = mkMerge [
        # Skipping list:
        # Rust: rust-analyzer is installed in home.devenv.rust;

        # Essential LSP/Formatters
        (with pkgs; [
          # nix
          nil
          nixfmt-rfc-style

          # bash
          bash-language-server
          shfmt

          # markdown
          marksman
          markdown-oxide

          # yaml
          yaml-language-server
          yamlfmt

          # toml
          taplo

          # json/jsonc
          nodePackages_latest.vscode-json-languageserver
        ])

        # Python
        # (mkIf (config.home.devenv.python.enable) (with pkgs; [ python312Packages.python-lsp-server ]))

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
