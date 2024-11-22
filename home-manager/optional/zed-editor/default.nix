# Ref:
# https://github.com/nix-community/home-manager/blob/master/modules/programs/zed-editor.nix
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
          light = "Github Light High Contrast";
          dark = "Github Dark Tritanopia";
        };
        features = {
          copilot = mkDefault false;
        };
        vim_mode = mkDefault true;
        tab_size = mkDefault 2;

        ui_font_size = mkDefault 22;
        buffer_font_size = mkDefault 20;
        buffer_font_family = mkDefault "BlexMono Nerd Font Mono";
        ui_font_family = mkDefault "BlexMono Nerd Font Mono";

        terminal = {
          font_family = mkDefault "FiraCode Nerd Font Mono";
          font_size = mkDefault 18;
          env = {
            TERM = "xterm-256color";
          };
        };

        auto_update = mkDefault false;

        confirm_quit = mkDefault true;

        tabs = {
          close_position = mkDefault "right";
          file_icons = mkDefault true;
          git_status = mkDefault true;
          activate_on_close = mkDefault "history";
        };

        proxy = mkDefault "http://localhost:7890";

        languages = {
          "Nix" = {
            "formatter" = {
              "external" = {
                command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
                arguments = [ "-s" ];
              };
            };
          };
        };

      };

      extensions = [ ];

    };

    home.packages = with pkgs; [
      nixd
      nixfmt-rfc-style
    ];
  };
}
