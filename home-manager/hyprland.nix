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
          "$mod, r, exec, hyprctl keyword monitor '${externalMonDisabled}'; sleep 1; hyprctl keyword monitor '${externalMonEnabled}'"
          "$mod_shift, r, exec, ${externalReenable}"

          "$mod_shift, q, killactive, "

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
      ];

      exec-once = [
        "eww daemon"
        "eww open bar_1"
      ];
    };
  };
}
