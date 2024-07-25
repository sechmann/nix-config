{
  pkgs,
  lib,
  ...
}: {
  home.packages = [pkgs.kanshi];
  services.kanshi = {
    enable = true;
    systemdTarget = "sway-session.target";
    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "eDP-1";
            mode = "1920x1200@60.026Hz";
            status = "enable";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "LG Electronics LG TV SSCR2 0x01010101";
            mode = "3840x2160@120.000Hz";
            position = "0,0";
            status = "enable";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
    ];
  };

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
        "XF86AudioPlay" = "exec ${pkgs.playerctl}/bin/playerctl -p spotify play-pause";
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
          # other
          (for_window_app_id "firefox" ".*" "border pixel 2")
          (for_window_app_id "org.wezfurlong.wezterm" ".*" "border pixel 2")
          (for_window_app_id "foot" ".*" "border pixel 2")
        ];
      };
    };
  };
  services.swayidle = {
    enable = true;
    systemdTarget = "sway-session.target";
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.playerctl}/bin/playerctl pause; if ! pgrep -x swaylock; then ${pkgs.swaylock}/bin/swaylock -f; fi";
      }
      {
        event = "lock";
        command = "${pkgs.playerctl}/bin/playerctl pause; if ! pgrep -x swaylock; then ${pkgs.swaylock}/bin/swaylock -f; fi";
      }
      {
        event = "after-resume";
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms on'";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.playerctl}/bin/playerctl pause; if ! pgrep -x swaylock; then ${pkgs.swaylock}/bin/swaylock -f; fi";
      }
      {
        timeout = 320;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
      {
        timeout = 600;
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms off'";
      }
    ];
  };
  programs.swaylock = {
    enable = true;
    settings = {
      font-size = 24;
      indicator-idle-visible = false;
      indicator-radius = 200;
      show-failed-attempts = true;
      color = "1e1e2e";
      bs-hl-color = "f5e0dc";
      caps-lock-bs-hl-color = "f5e0dc";
      caps-lock-key-hl-color = "a6e3a1";
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color = "a6e3a1";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cdd6f4";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "b4befe";
      ring-clear-color = "f5e0dc";
      ring-caps-lock-color = "fab387";
      ring-ver-color = "89b4fa";
      ring-wrong-color = "eba0ac";
      separator-color = "00000000";
      text-color = "cdd6f4";
      text-clear-color = "f5e0dc";
      text-caps-lock-color = "fab387";
      text-ver-color = "89b4fa";
      text-wrong-color = "eba0ac";
    };
  };
}
