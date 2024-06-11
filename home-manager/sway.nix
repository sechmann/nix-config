{
  pkgs,
  lib,
  ...
}: let
  tvOutput = "LG Electronics LG TV SSCR2 0x01010101";
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "sway-session.target";
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "${tvOutput}"
        ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "wlr/taskbar"
        ];
        modules-center = ["sway/window"];
        modules-right = [
          "battery"
          "backlight"
          "network"
          "bluetooth"
          "wireplumber"
          "clock"
          "tray"
        ];

        "sway/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
        };
      };
    };
  };

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
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
    ];
  };

  wayland.windowManager.sway = {
    checkConfig = false; # doesn't work with custom keyboard layout nix-community/home-manager#5311
    enable = true;
    wrapperFeatures = {
      gtk = true;
      base = true;
    };
    systemd.enable = true;
    config = let
      modifier = "Mod4";
      fixExternalMonitor = pkgs.writeShellScript "external-monitor.sh" ''
        swaymsg output '"LG Electronics LG TV SSCR2 0x01010101"' disable
        swaymsg output '"LG Electronics LG TV SSCR2 0x01010101"' enable
        swaymsg output '"LG Electronics LG TV SSCR2 0x01010101"' mode 3840x2160@120.000Hz pos 0 0
      '';
    in {
      modifier = "${modifier}";
      keybindings = lib.mkOptionDefault {
        "${modifier}+d" = "exec ${pkgs.kickoff}/bin/kickoff";
        "Ctrl+Alt+l" = "exec swaylock";
        "${modifier}+r" = "exec ${fixExternalMonitor}";
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
        };
      };
      bars = [];
      terminal = "wezterm";
      window = {
        commands = [
          # zoom wayland
          {
            criteria = {
              app_id = "Zoom Workplace";
            };
            command = "floating enable";
          }
          {
            criteria = {
              app_id = "Zoom Workplace";
              title = ".*Zoom Meeting";
            };
            command = "inhibit_idle visible";
          }
          {
            criteria = {
              app_id = "Zoom Workplace";
              title = ".*Zoom Meeting";
            };
            command = "floating disable";
          }
          # zoom x
          {
            criteria = {
              class = "zoom";
              title = "(zoom)|(Breakout rooms -.*)";
            };
            command = "floating enable";
          }
          {
            criteria = {
              class = "zoom";
              title = ".*Zoom Meeting";
            };
            command = "inhibit_idle visible";
          }
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
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "after-resume";
        command = "swaymsg 'output * dpms on';";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 320;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
      {
        timeout = 310;
        command = "swaymsg 'output * dpms off'";
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
