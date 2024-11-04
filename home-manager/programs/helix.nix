{ lib, pkgs, ... }:
let
  inherit (lib) mkDefault mkEnableOption;
in
{
  options.home.programs.helix = {
    enable = mkEnableOption "helix editor in home-manager";
  };

  config = {
    home.programs.helix = {
      enable = mkDefault true; # 默认安装 helix
    };

    # 默认 helix 配置
    # 可以在其他配置文件中 override
    programs.helix = {
      defaultEditor = mkDefault true;
      settings = {
        theme = mkDefault "github_dark_tritanopia_transparent";
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
        {
          name = "yaml";
          auto-format = false;
          formatter = {
            command = "yamlfmt";
            args = [ "-" ];
          };
        }
        # Shell
        {
          name = "bash";
          auto-format = false;
          formatter = {
            command = "shfmt";
            args = [
              # simplify and minimize code
              # visit for more details: 
              # https://github.com/mvdan/sh/blob/master/cmd/shfmt/shfmt.1.scd
              "-s"
              "-mn"
              "-"
            ];
          };
        }
      ];

      # To support filetypes defaultly  etc: 
      # Bash, yaml, markdown, nix so on
      extraPackages = with pkgs; [
        # Bash
        nodePackages.bash-language-server
        shfmt

        # Nix
        nil
        nixfmt-rfc-style

        # Markdown
        marksman
        markdown-oxide

        # Yaml
        yaml-language-server
        yamlfmt
      ];
    };

    # 自定义透明背景
    xdg.configFile."helix/themes/github_dark_tritanopia_transparent.toml" = {
      text = ''
        inherits = "github_dark_tritanopia"
        "ui.background" = {}
      '';
    };
  };
}
