{ config, pkgs, lib, niri, ... }:

{
  programs.niri = {
    settings = {
      prefer-no-csd = true;

      input = {
        keyboard.xkb.layout = "us";
        mouse = {
          accel-speed = 0.0;
          accel-profile = "flat";
        };
      };

      outputs."*" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 360.0;
        };
        scale = 1.0;
      };

      layout = {
        gaps = 4;
        border = {
          enable = true;
          width = 2;
        };
        focus-ring.enable = false;
      };

      spawn-at-startup = [
        { command = [ "wl-clip-persist" "--clipboard" "regular" ]; }
      ];

      environment = {
        NIXOS_OZONE_WL = "1";
        __GL_MaxFramesAllowed = "1";
        __GL_GSYNC_ALLOWED = "0";
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
      };

      binds = with config.lib.niri.actions; {
        "Mod+T".action = spawn "ghostty";
        "Mod+E".action = spawn "dolphin";
        "Mod+B".action = spawn "zen";
        "Mod+Q".action = close-window;
        "Mod+F".action = maximize-column;
        "Mod+Shift+F".action = fullscreen-window;

        # Focus
        "Mod+H".action = focus-column-left;
        "Mod+J".action = focus-window-down;
        "Mod+K".action = focus-window-up;
        "Mod+L".action = focus-column-right;
        "Mod+Left".action = focus-column-left;
        "Mod+Down".action = focus-window-down;
        "Mod+Up".action = focus-window-up;
        "Mod+Right".action = focus-column-right;

        # Move windows
        "Mod+Shift+H".action = move-column-left;
        "Mod+Shift+J".action = move-window-down;
        "Mod+Shift+K".action = move-window-up;
        "Mod+Shift+L".action = move-column-right;
        "Mod+Shift+Left".action = move-column-left;
        "Mod+Shift+Down".action = move-window-down;
        "Mod+Shift+Up".action = move-window-up;
        "Mod+Shift+Right".action = move-column-right;

        # Workspaces
        "Mod+1".action = focus-workspace 1;
        "Mod+2".action = focus-workspace 2;
        "Mod+3".action = focus-workspace 3;
        "Mod+4".action = focus-workspace 4;
        "Mod+5".action = focus-workspace 5;
        "Mod+6".action = focus-workspace 6;
        "Mod+7".action = focus-workspace 7;
        "Mod+8".action = focus-workspace 8;
        "Mod+9".action = focus-workspace 9;
        "Mod+Shift+1".action = move-column-to-workspace 1;
        "Mod+Shift+2".action = move-column-to-workspace 2;
        "Mod+Shift+3".action = move-column-to-workspace 3;
        "Mod+Shift+4".action = move-column-to-workspace 4;
        "Mod+Shift+5".action = move-column-to-workspace 5;
        "Mod+Shift+6".action = move-column-to-workspace 6;
        "Mod+Shift+7".action = move-column-to-workspace 7;
        "Mod+Shift+8".action = move-column-to-workspace 8;
        "Mod+Shift+9".action = move-column-to-workspace 9;

        # Column sizing
        "Mod+Minus".action = set-column-width "-10%";
        "Mod+Equal".action = set-column-width "+10%";
        "Mod+Shift+Minus".action = set-window-height "-10%";
        "Mod+Shift+Equal".action = set-window-height "+10%";

        # Screenshots
        "Print".action = screenshot;
        "Mod+Print".action = screenshot-screen;
        "Mod+Shift+Print".action = screenshot-window;

        # Consume / expel
        "Mod+BracketLeft".action = consume-or-expel-window-left;
        "Mod+BracketRight".action = consume-or-expel-window-right;

        # Tab overview
        "Mod+D".action = toggle-overview;
        "Mod+Tab".action = toggle-overview;

        # Quit niri
        "Mod+Shift+E".action = quit;
      };

      window-rules = [
        {
          matches = [{ app-id = "^org\\.gnome\\."; }];
          draw-border-with-background = false;
        }
        {
          matches = [{ app-id = "^org\\.kde\\.dolphin$"; }];
          default-column-width = { proportion = 0.5; };
        }
        {
          matches = [
            { app-id = "^org\\.gnome\\.Calculator$"; }
            { app-id = "^gnome-calculator$"; }
            { app-id = "^pavucontrol$"; }
          ];
          open-floating = true;
        }
      ];
    };
  };
}
