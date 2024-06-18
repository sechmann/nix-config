{pkgs, ...}: let
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
      /* gruvbox */
      @define-color background #1d2021;
      @define-color foreground #d4be98;

      @define-color blue #7daea3;
      @define-color mauve #d3869b;
      @define-color maroon #d65d0e;
      @define-color yellow #d8a657;
      @define-color lavender #89b482;

      * {
          font-family: "Iosevka Nerd Font";
          font-size: 16px;
          min-height: 0;
          font-weight: bold;
      }

      window#waybar {
          background: transparent;
          background-color: @background;
          color: @foreground;
          transition-property: background-color;
          transition-duration: 0.1s;
      }

      #window {
          margin: 2;
          padding-left: 8;
          padding-right: 8;
      }

      button {
          box-shadow: inset 0 -3px transparent;
          border: none;
          border-radius: 0;
      }

      button:hover {
          background: inherit;
          border-top: 2px solid @hover;
      }

      #workspaces button {
          padding: 0 4px;
      }

      #workspaces button.focused {
          background-color: rgba(0, 0, 0, 0.3);
          color: @blue;
          border-top: 2px solid @blue;
      }

      #workspaces button.urgent {
          background-color: #eb4d4b;
      }

      #pulseaudio,
      #clock,
      #battery,
      #cpu,
      #memory,
      #disk,
      #temperature,
      #backlight,
      #wireplumber,
      #tray,
      #mode,
      #scratchpad {
          margin: 2px;
          padding-left: 4px;
          padding-right: 4px;
      }

      #clock {
          color: @maroon;
          border-bottom: 2px solid @maroon;
      }

      #clock.date {
          color: @mauve;
          border-bottom: 2px solid @mauve;
      }

      #pulseaudio {
          color: @blue;
          border-bottom: 2px solid @blue;
      }

      #network {
          color: @yellow;
          border-bottom: 2px solid @yellow;
      }

      #idle_inhibitor {
          margin-right: 12px;
          color: #7cb342;
      }

      #idle_inhibitor.activated {
          color: @red;
      }

      #battery.charging,
      #battery.plugged {
          color: @green;
          border-bottom: 2px solid @green;
      }

      /* If workspaces is the leftmost module, omit left margin */
      .modules-left>widget:first-child>#workspaces {
          margin-left: 0;
      }

      /* If workspaces is the rightmost module, omit right margin */
      .modules-right>widget:last-child>#workspaces {
          margin-right: 0;
      }

      #custom-vpn {
          color: @lavender;
          border-radius: 15px;
          padding-left: 6px;
          padding-right: 6px;
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32;
        spacing = 10;
        modules-left = [
          "sway/workspaces"
          "sway/mode"
        ];
        modules-center = ["sway/window"];
        modules-right = [
          "tray"
          "wireplumber"
          "battery"
          "backlight"
          "network"
          "bluetooth"
          "clock"
          "clock#date"
        ];

        "sway/mode" = {
          format = "<span style=\"italic\">{}</span>";
        };

        "sway/scratchpad" = {
          "format" = "{icon} {count}";
          "show-empty" = false;
          "format-icons" = [
            ""
            ""
          ];
          "tooltip" = true;
          "tooltip-format" = "{app}: {title}";
        };

        "sway/window" = {
          #"on-click" = "ags -t datemenu";
          "tooltip" = false;
        };
        "idle_inhibitor" = {
          "format" = "{icon}";
          "format-icons" = {
            "activated" = "";
            "deactivated" = "";
          };
        };
        "tray" = {
          "spacing" = 10;
        };
        "clock" = {
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          "format-alt" = "{:%Y-%m-%d}";
        };
        "clock#date" = {
          "format" = "{:%d.%m.%Y}";
          "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        };
        "backlight" = {
          "format" = "{icon} {percent}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
            ""
          ];
        };
        "battery" = {
          "states" = {
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{icon} {capacity}%";
          "format-charging" = " {capacity}%";
          "format-plugged" = " {capacity}%";
          "format-icons" = [
            ""
            ""
            ""
            ""
            ""
          ];
          #"on-click" = "ags -t quicksettings";
        };
        "wireplumber" = {
          "format" = "{icon} {volume}% {format_source}";
          "format-bluetooth" = " {icon} {volume}% {format_source}";
          "format-bluetooth-muted" = "  {icon} {format_source}";
          "format-muted" = "  {format_source}";
          "format-source" = " {volume}%";
          "format-source-muted" = "";
          "format-icons" = {
            "default" = [
              ""
              ""
              ""
            ];
          };
          "on-click" = "pavucontrol";
        };
        "custom/weather" = {
          "format" = "{}";
          "interval" = 600;
          "exec" = "curl -s 'https://wttr.in/Oslo,Norway?format=1'";
          "exec-if" = "ping wttr.in -c1";
        };
        # "custom/vpn" = {
        #   "tooltip" = false;
        #   "format" = "VPN {} ";
        #   "exec" = "mullvad status | grep -q 'Connected' && echo '' || echo ''";
        #   "interval" = 5;
        #   "on-click" = "mullvad connect";
        #   "on-click-right" = "mullvad disconnect";
        # };
        "network" = {
          "format-wifi" = " {essid} ({signalStrength}%)";
          "format-ethernet" = "⬇{bandwidthDownBytes} ⬆{bandwidthUpBytes}";
          "interval" = 3;
          "format-linked" = "{ifname} (No IP) ";
          "format" = "";
          "format-disconnected" = "";
          "format-alt" = "{ifname}: {ipaddr}/{cidr}";
          "tooltip-format" = " {bandwidthUpBits}  {bandwidthDownBits}\n{ifname}\n{ipaddr}/{cidr}\n";
          "tooltip-format-wifi" = " {essid} {frequency}MHz\nStrength: {signaldBm}dBm ({signalStrength}%)\nIP: {ipaddr}/{cidr}\n {bandwidthUpBits}  {bandwidthDownBits}";
          "min-length" = 17;
          "max-length" = 17;
        };
      };
    };
  };
}
