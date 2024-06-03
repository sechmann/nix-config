{ pkgs, ... }:
let
  laptopMon = "desc:AU Optronics 0xF99A";
  laptopMonEnabled = "${laptopMon},1920x1200@60.03Hz,3840x0,1";
  laptopMonDisabled = "${laptopMon},disable";
  externalMon = "desc:LG Electronics LG TV SSCR2 0x01010101";
  externalMonDisabled = "${externalMon},disable";
  externalMonEnabled = "${externalMon},3840x2160@120.00Hz,0x0,1,bitdepth,10";

  hyprctl = "${pkgs.hyprland}/bin/hyprctl keyword monitor";
  externalReenable = "${hyprctl} '${externalMon},disable'; ${hyprctl} '${externalMon},3840x2160@120.00Hz,0x0,1,bitdepth,10'";

  wallpaper = builtins.fetchurl {
    url = "https://w.wallhaven.cc/full/we/wallhaven-werowr.png";
    sha256 = "0dkhzw74m49h5rmmdd59x0m878v1csq73arz75i03hs3pfklhjwj";
  };
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      monitor = [
        externalMonEnabled
        laptopMonEnabled
      ];
      decoration = {
        shadow_offset = "0 5";
        "col.shadow" = "rgba(00000099)";
      };

      input = {
        kb_layout = "us-no";
      };

      "$mod" = "SUPER";
      bind =
        [
          "$mod, f, fullscreen, 0" # 0 - fullscreen (takes your entire screen), 1 - maximize (keeps gaps and bar(s)), 2 - fullscreen (same as fullscreen except doesn’t alter window’s internal fullscreen state)
          "$mod-shift, f, fakefullscreen"
          "$mod, return, exec, wezterm"
          "$mod, d, exec, ${pkgs.kickoff}/bin/kickoff"
          ", Print, exec, grimblast copy area"

          "$mod, space, togglefloating, active"

          "$mod_shift, q, killactive, "
          "ctrl_alt, l, exec, ${pkgs.hyprlock}/bin/hyprlock"

          "$mod, h, movefocus, l"
          "$mod, j, movefocus, d"
          "$mod, k, movefocus, u"
          "$mod, l, movefocus, r"

          "$mod_shift, h, movewindow, l"
          "$mod_shift, j, movewindow, d"
          "$mod_shift, k, movewindow, u"
          "$mod_shift, l, movewindow, r"
        ]
        ++ (
          # workspaces
          # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
          builtins.concatLists (
            builtins.genList (
              x:
              let
                ws =
                  let
                    c = (x + 1) / 10;
                  in
                  builtins.toString (x + 1 - (c * 10));
              in
              [
                "$mod, ${ws}, workspace, ${toString (x + 1)}"
                "$mod SHIFT, ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
              ]
            ) 10
          )
        );

      bindm = [
        # mouse movements
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];

      bindl = [
        ",switch:on:Lid Switch,exec,hyprctl keyword monitor '${externalMonEnabled}' && hyprctl keyword monitor '${laptopMonDisabled}'"
        ",switch:off:Lid Switch,exec,hyprctl keyword monitor '${externalMonEnabled}' && hyprctl keyword monitor '${laptopMonEnabled}'"
        "$mod, r, exec, hyprctl keyword monitor '${externalMonDisabled}'; sleep 1; hyprctl keyword monitor '${externalMonEnabled}'"
        "$mod_shift, r, exec, ${externalReenable}"
      ];

      exec-once = [
        "eww daemon"
        "eww open bar_1"
        "${pkgs.hypridle}/bin/hypridle"
        "${pkgs.hyprpaper}/bin/hyprpaper"
      ];
    };
  };
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 5;
        hide_cursor = true;
        no_fade_in = false;
      };

      background = [
        {
          path = "screenshot";
          blur_passes = 3;
          blur_size = 8;
        }
      ];

      input-field = [
        {
          size = "200, 50";
          position = "0, -80";
          monitor = "";
          dots_center = true;
          fade_on_empty = true;
          font_color = "rgb(202, 211, 245)";
          inner_color = "rgb(91, 96, 120)";
          outer_color = "rgb(24, 25, 38)";
          outline_thickness = 2;
          placeholder_text = "password...";
          shadow_passes = 1;
        }
      ];
    };
  };
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || ${pkgs.hyprlock}/bin/hyprlock";
        before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        after_sleep_cmd = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on; ${externalReenable}";
      };
      listener = [
        {
          timeout = 150;
          on-timeout = "${pkgs.brightnessctl}/bin/brightnessctl -s set 10";
          on-resume = "${pkgs.brightnessctl}/bin/brightnessctl -r";
        }
        {
          timeout = 330;
          before_sleep_cmd = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 300;
          on-timeout = "${pkgs.systemd}/bin/loginctl lock-session";
        }
        {
          timeout = 330;
          on-timeout = "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
          on-resume = "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
        }
        {
          timeout = 1000;
          on-timeout = "${pkgs.systemd}/bin/systemctl suspend";
        }
      ];
    };
  };
  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      preload = [ wallpaper ];
      wallpaper = [ "${externalMon},${wallpaper}" ];
    };
  };
}
