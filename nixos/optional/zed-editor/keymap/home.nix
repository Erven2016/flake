{ lib, config, ... }:
let
  inherit (lib) mkIf mkEnableOption;

  cfg = config.home.programs.zed-editor;
in
{
  options.home.programs.zed-editor = {
    enableHelixKeymap = mkEnableOption "helix-like keymappings for zed-editor";
  };

  config = mkIf cfg.enableHelixKeymap {
    programs.zed-editor.userKeymaps = [
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
          # Zen Mode
          "alt-z" = "workspace::ToggleZoom";
        };
      }
    ];
  };
}
