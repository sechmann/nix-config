{ pkgs, lib, ... }:
{
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
          "DP-3"
        ];
        modules-left = [
          "sway/workspaces"
          "sway/mode"
          "wlr/taskbar"
        ];
        modules-center = [ "sway/window" ];
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

  home.packages = [ pkgs.kanshi ];
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
    config =
      let
        modifier = "Mod4";
      in
      {
        modifier = "${modifier}";
        keybindings = lib.mkOptionDefault {
          #"${modifier}+Shift+q" = "kill";
          #"${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
          "${modifier}+d" = "exec ${pkgs.kickoff}/bin/kickoff";
          "Ctrl+Alt+l" = "exec swaylock";
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
        bars = [ ];
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
}
