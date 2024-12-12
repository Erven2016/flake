# Avaliable Options: https://github.com/nix-community/home-manager/blob/master/modules/programs/zed-editor.nix
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
    mkDefault
    mkForce
    mkBefore
    ;

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
      enable = mkForce true;
      package = mkIf cfg.enableUnstableVersion pkgs.unstable.zed-editor;

      userSettings = {
        theme = {
          mode = mkDefault "system";
          light = mkDefault "Catppuccin Latte";
          dark = mkDefault "Catppuccin Macchiato";
        };

        features = {
          copilot = mkDefault false;
        };

        assistant = {
          enable = mkDefault false;
          button = mkDefault false;
        };

        vim_mode = mkDefault true;
        tab_size = mkDefault 2;

        # Fonts Options
        ui_font_size = mkDefault 20;
        buffer_font_size = mkDefault 20;
        ui_font_weight = mkDefault 500;
        buffer_font_weight = mkDefault 500;
        buffer_font_family = mkDefault "BlexMono Nerd Font Mono";
        ui_font_family = mkDefault "Zed Plex Sans";
        terminal.font_familly = mkDefault "FiraCode Nerd Font Mono";
        terminal.font_size = mkDefault 18;

        # Terminal Options
        terminal = {
          env = {
            # fix: can't use deleting key in terminal
            TERM = mkForce "xterm-256color";
          };
        };

        wrap_guides = [ 80 ];

        node = {
          path = lib.getExe pkgs.nodejs;
          npm_path = lib.getExe' pkgs.nodejs "npm";
        };

        hour_format = mkDefault "hour24";

        auto_update = mkDefault false;

        confirm_quit = mkDefault true;

        # open a history project can not activate direnv
        # To open a history project can use keymap `Ctrl`-`Alt`-`o`
        # , and direnv will be activate
        restore_on_startup = mkDefault "none";

        # direnv integration
        load_direnv = mkDefault "shell_hook";

        tabs = {
          close_position = mkDefault "right";
          file_icons = mkDefault true;
          git_status = mkDefault true;
          activate_on_close = mkDefault "history";
          always_show_close_button = mkDefault true;
        };

        proxy = mkDefault "http://localhost:7890";

        languages = {
          # Nix language
          "Nix" = {
            tab_size = mkDefault 2;
            "formatter" = {
              "external" = {
                command = mkDefault "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
                arguments = mkDefault [ "-s" ];
              };
            };
            "language_servers" = mkDefault [
              "nixd"
              "!nil" # disable nil
            ];
          };
          # Rust language
          "Rust" = {
            tab_size = mkDefault 4;
            hard_tabs = mkDefault false;
          };
        };
      };

      # List of extensions
      # https://github.com/zed-industries/extensions/tree/main/extensions
      extensions = mkDefault [
        "catppuccin" # Theme
        "nix" # nix language support
        "env"
      ];

      userKeymaps = mkBefore [
        # In normal & visual mode
        {
          context = "Editor && (vim_mode == normal || vim_mode == visual)";
          bindings = {
            # Helix-like keymappings
            "g g" = "vim::StartOfDocument";
            "g e" = "vim::EndOfDocument";
            "g h" = "vim::StartOfLine";
            "g l" = "vim::EndOfLine";
            "space c" = "vim::ToggleComments";
            "U" = "vim::Redo";

            # Custom keymappings
            "ctrl-j" = [
              "workspace::SendKeystrokes"
              "down down down down"
            ];
            "ctrl-k" = [
              "workspace::SendKeystrokes"
              "up up up up"
            ];
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
        {
          bindings = {
            "alt-z" = "workspace::ToggleZoom";
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
