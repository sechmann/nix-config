{
  pkgs,
  lib,
  ...
}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        output = [
          "eDP-1"
          "DP-3"
        ];
        modules-left = ["sway/workspaces" "sway/mode" "wlr/taskbar"];
        modules-center = ["sway/window"];
        modules-right = ["battery" "backlight" "network" "bluetooth" "wireplumber" "clock" "tray"];

        "sway/workspaces" = {
          disable-scroll = false;
          all-outputs = true;
        };
      };
    };
  };

  services.swayidle = {
    enable = true;
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
        command = "swaymsg 'output * dpms on'";
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
    in {
      modifier = "${modifier}";
      keybindings = lib.mkOptionDefault {
        #"${modifier}+Shift+q" = "kill";
        #"${modifier}+d" = "exec ${pkgs.dmenu}/bin/dmenu_path | ${pkgs.dmenu}/bin/dmenu | ${pkgs.findutils}/bin/xargs swaymsg exec --";
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
      output = {
        DP-3 = {
          mode = "3840x2160@120.000Hz";
          pos = "0 0";
        };
      };
      bars = [];
      terminal = "wezterm";
      window = {
        commands = [
          {
            criteria = {
              class = "zoom";
              title = "(zoom)|(Breakout rooms -.*)";
            };
            command = "floating enable";
          }
        ];
      };
    };
  };
}
