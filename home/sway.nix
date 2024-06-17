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
    package = pkgs.waybar.override {
      cavaSupport = false;
      hyprlandSupport = false;
      mpdSupport = false;
      mprisSupport = false;
      pulseSupport = false;
      sndioSupport = false;
    };
    style = ''
      /* Universal styling */
      * {
        border: none;
        border-radius: 0;
        font-family:
          JetBrainsMono Nerd Font,
          Helvetica,
          Arial,
          sans-serif;
        font-size: 16px;
        min-height: 16px;
      }

      /* Main Waybar window styling */
      window#waybar {
        background-color: rgba(0, 0, 0, 0.5);
        color: #cccccc;
        transition: background-color 0.5s;
      }

      window#waybar.hidden {
        opacity: 0.2;
      }

      /* Workspace button styling */
      #workspaces button {
        padding: 0 5px;
        margin-right: 1px;
        color: #555555;
        border-radius: 4px;
        transition:
          background-color 0.3s ease,
          color 0.3s ease;
        background: rgba(0, 0, 0, 0.1);
      }

      #workspaces button:hover {
        background-color: rgba(50, 50, 50, 0.5);
        color: #ffffff;
      }

      #workspaces button.active {
        background: linear-gradient(
          rgba(255, 255, 255, 0.6),
          rgba(255, 255, 255, 0.5)
        );
        color: #000000;
        text-shadow: 0px 1px 0 rgba(255, 255, 255, 0.35);
      }

      #workspaces button.urgent {
        background-color: #fb4934;
        color: #282828;
        animation: urgentBlink 1s linear infinite alternate;
      }

      @keyframes urgentBlink {
        to {
          background-color: #fb6655;
        }
      }

      /* Mode styling */
      #mode {
        background-color: #64727d;
        border-bottom: 3px solid #ffffff;
      }

      /* General module styling */
      #clock,
      #battery,
      #backlight,
      #network,
      #pulseaudio,
      #mode,
      #mpd {
        margin: 0 0px;
      }

      #clock {
        padding-left: 10px;
        padding-right: 10px;
      }

      #network {
        padding-left: 20px;
        padding-right: 10px;
      }

      /* Module specific styling with shared background and color */
      #clock,
      #custom-mousebattery,
      #battery,
      #battery.charging,
      #backlight,
      #bluetooth,
      #network,
      #network.disconnected,
      #pulseaudio,
      #pulseaudio.muted,
      #wireplumber,
      #tray {
        background: linear-gradient(
          rgba(255, 255, 255, 0.6),
          rgba(255, 255, 255, 0.5)
        );
        color: #000000;
        text-shadow: 0px 1px 0 rgba(255, 255, 255, 0.35);
        font-family: JetBrainsMono Nerd Font;
        font-size: 14px;
      }

      #battery.critical:not(.charging) {
        background-color: #282828;
        color: #282828;
        animation: blink 1s linear infinite alternate;
      }

      @keyframes blink {
        to {
          background-color: #ebdbb2;
          color: #282828;
        }
      }

      label:focus {
        background-color: #000000;
      }

      #custom-mousebattery {
        border-radius: 5px 0px 0px 5px;
        padding-left: 10px;
        padding-right: 20px;
      }
    '';
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
        ];
        modules-center = ["sway/window"];
        modules-right = [
          "tray"
          "battery"
          "backlight"
          "network"
          "bluetooth"
          "wireplumber"
          "clock"
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
        command = "pidof swaylock || ${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "lock";
        command = "pidof swaylock || ${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        event = "after-resume";
        command = "${pkgs.sway}/bin/swaymsg 'output * dpms on';";
      }
    ];
    timeouts = [
      {
        timeout = 300;
        command = "pidof swaylock || ${pkgs.swaylock}/bin/swaylock -f";
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
