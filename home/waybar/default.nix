{pkgs, ...}: {
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
    style = builtins.readFile ./style.css;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 24;
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
          "custom/notification"
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
          # "format" = "{icon} {volume}% {format_source}";
          # "format-bluetooth" = " {icon} {volume}% {format_source}";
          # "format-bluetooth-muted" = "  {icon} {format_source}";
          # "format-muted" = "  {format_source}";
          # "format-source" = " {volume}%";
          # "format-source-muted" = "";
          # "format-icons" = {
          #   "default" = [
          #     ""
          #     ""
          #     ""
          #   ];
          # };
          "on-click" = "pavucontrol";
        };
        "custom/weather" = {
          "format" = "{}";
          "interval" = 600;
          "exec" = "curl -s 'https://wttr.in/Oslo,Norway?format=1'";
          "exec-if" = "ping wttr.in -c1";
        };
        "custom/notification" = {
          "max-length" = 4;
          "tooltip" = false;
          "format" = "{icon}";
          "format-icons" = {
            "notification" = "<span foreground='red'><sup></sup></span>";
            "none" = "";
            "dnd-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-none" = "";
            "inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "inhibited-none" = "";
            "dnd-inhibited-notification" = "<span foreground='red'><sup></sup></span>";
            "dnd-inhibited-none" = "";
          };
          "return-type" = "json";
          "exec-if" = "ls ${pkgs.swaynotificationcenter}/bin/swaync-client";
          "exec" = "${pkgs.swaynotificationcenter}/bin/swaync-client -swb";
          "on-click" = "${pkgs.swaynotificationcenter}/bin/swaync-client -t -sw";
          "on-click-right" = "${pkgs.swaynotificationcenter}/bin/swaync-client -d -sw";
          "escape" = true;
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
