{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.sway = let
    modifier = "Mod4";
    fixExternalMonitor = pkgs.writeShellScript "external-monitor.sh" ''
      ${pkgs.sway}/bin/swaymsg output '"LG Electronics LG TV SSCR2 0x01010101"' disable
      ${pkgs.sway}/bin/swaymsg output '"LG Electronics LG TV SSCR2 0x01010101"' enable
      ${pkgs.sway}/bin/swaymsg output '"LG Electronics LG TV SSCR2 0x01010101"' mode 3840x2160@120.000Hz pos 0 0
    '';
  in {
    checkConfig = false; # doesn't work with custom keyboard layout nix-community/home-manager#5311
    enable = true;
    wrapperFeatures = {
      gtk = true;
      base = true;
    };
    systemd.enable = true;
    config = {
      modifier = "${modifier}";
      keybindings = lib.mkOptionDefault {
        "${modifier}+d" = "exec ${pkgs.kickoff}/bin/kickoff";
        "Ctrl+Alt+l" = "exec ${pkgs.swaylock}/bin/swaylock";
        "--locked ${modifier}+Shift+r" = "exec ${fixExternalMonitor}";
        "XF86AudioNext" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify next";
        "XF86AudioPrev" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify previous";
        "${modifier}+Shift+s" = "exec grim -g \"$(slurp)\" - | wl-copy";
      };
      keycodebindings = {
        #"171" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify next";
        #"173" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
        #"172" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify previous";
      };

      fonts = {
        size = 11.0;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us-no";
        };
        "type:touchpad" = {
          natural_scroll = "enabled";
          tap = "enabled";
        };
      };
      bars = [];
      terminal = "foot";
      gaps = {
        outer = 10;
        inner = 5;
        smartBorders = "on";
      };
      window = {
        commands = let
          for_window_app_id = app_id: title: command: {
            criteria = {
              app_id = app_id;
              title = title;
            };
            command = command;
          };
          for_window_class = class: title: command: {
            criteria = {
              class = class;
              title = title;
            };
            command = command;
          };
        in [
          # For pop up notification windows that don't use notifications api
          (for_window_class "zoom" "^zoom$" "border none, floating enable")
          # For specific Zoom windows
          (for_window_class "zoom" "^(Zoom|About)$" "border pixel, floating enable")
          (for_window_class "zoom" "Settings" "floating enable, floating_minimum_size 960 x 700")
          # Open Zoom Meeting windows on a new workspace (a bit hacky)
          (for_window_class "zoom" "Zoom Meeting(.*)?" "workspace next_on_output --create, move container to workspace current, floating disable, inhibit_idle visible")
          (for_window_class "zoom" "\.zoom" "workspace 11 --create, move container to workspace 11, floating enable")
          # other
          (for_window_app_id "firefox" ".*" "border pixel 2")
          (for_window_app_id "zen-alpha" ".*" "border pixel 2")
          (for_window_app_id "org.wezfurlong.wezterm" ".*" "border pixel 2")
          (for_window_app_id "foot" ".*" "border pixel 2")
        ];
      };
    };
  };
}
