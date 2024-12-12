# Avaliable Options: https://github.com/nix-community/home-manager/blob/master/modules/programs/zed-editor.nix
{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.home.programs.zed-editor;
in
{
  options.home.programs.zed-editor = {
    enable = mkEnableOption "zed-editor";
    enableUnstableVersion = mkEnableOption "unstable version of zed-editor" // {
      default = true;
    };
  };
  config = {
    programs.zed-editor = mkIf cfg.enable {
      enable = true;
      package = mkIf cfg.enableUnstableVersion pkgs.unstable.zed-editor;

      userSettings = {
        theme = {
          mode = "system";
          light = "Catppuccin Latte";
          dark = "Catppuccin Macchiato";
        };

        features = {
          copilot = mkDefault false;
        };

        vim_mode = mkDefault true;
        tab_size = mkDefault 2;

        ui_font_size = mkDefault 20;
        buffer_font_size = mkDefault 18;
        buffer_font_family = mkDefault "BlexMono Nerd Font Mono";
        ui_font_family = mkDefault "Zed Plex Sans";

        terminal = {
          font_family = mkDefault "FiraCode Nerd Font Mono";
          font_size = mkDefault 18;
          env = {
            TERM = "xterm-256color";
          };
        };

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        hour_format = "hour24";

        auto_update = mkDefault false;

        confirm_quit = mkDefault true;
        restore_on_startup = "none";

        tabs = {
          close_position = mkDefault "right";
          file_icons = mkDefault true;
          git_status = mkDefault true;
          activate_on_close = mkDefault "history";
        };

        proxy = mkDefault "http://localhost:7890";

        # direnv integration
        load_direnv = "shell_hook";

        languages = {
          # Nix language
          "Nix" = {
            tab_size = 2;
            "formatter" = {
              "external" = {
                command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
                arguments = [ "-s" ];
              };
            };
            "language_servers" = [
              "nixd"
              "!nil" # disable nil
            ];
          };
          # Rust language
          "Rust" = {
            tab_size = 4;
            hard_tabs = false;
          };
        };
      };

      # List of extensions
      # https://github.com/zed-industries/extensions/tree/main/extensions
      extensions = [
        "catppuccin"
        "nix"
        "env"
      ];

      userKeymaps = [
        # In normal & visual mode
        {
          context = "Editor && (vim_mode == normal || vim_mode == visual)";
          bindings = {
            # Helix-like keymappings
            "g e" = "vim::EndOfDocument";
            "g h" = "vim::StartOfLine";
            "g l" = "vim::EndOfLine";
            "space c" = "vim::ToggleComments";
            "U" = "vim::Redo";
          };
        }

        # In normal mode
        {
          context = "Editor && vim_mode == normal";
          bindings = {
            # Helix like keymappings
            "space f" = "file_finder::Toggle";

            # format buffer
            "space i" = "editor::Format";
            # global search
            "space /" = "workspace::NewSearch";
            # go to line
            "space g" = "go_to_line::Toggle";
          };
        }
      ];
    };

    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };
}
