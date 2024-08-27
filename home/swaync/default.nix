{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = {
    "$schema" = "${pkgs.swaynotificationcenter}/etc/xdg/swaync/configSchema.json";
    positionX = "right";
    positionY = "top";
    control-center-margin-top = 10;
    control-center-margin-bottom = 10;
    control-center-margin-right = 10;
    control-center-margin-left = 10;
    widgets = [
      #"buttons-grid"
      "dnd"
      "title"
      "notifications"
    ];
    widget-config = {
      buttons-grid.actions = [
        # {
        #   label = "󰐥";
        #   command = "systemctl poweroff";
        # }
        # {
        #   label = "󰑐";
        #   command = "systemctl reboot";
        # }
        # {
        #   label = "󰌿";
        #   command = "hyprlock";
        # }
      ];
      dnd = {
        text = "Do not disturb";
      };
      title = {
        text = "Notifications";
        clear-all-button = true;
        button-text = "󰆴";
      };
    };
  };
in {
  home.packages = with pkgs; [
    swaynotificationcenter
  ];

  services.swaync = {
    enable = true;
    style = ./style.css;
    settings = cfg;
  };

  systemd.user.services.swaync = {
    Unit = {
      Description = "Swaync notification daemon";
      Documentation = "https://github.com/ErikReider/SwayNotificationCenter";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session-pre.target"];
      ConditionEnvironment = "WAYLAND_DISPLAY";

      X-Restart-Triggers = [
        "${config.xdg.configFile."swaync/config.json".source}"
        "${config.xdg.configFile."swaync/style.css".source}"
      ];
    };
  };
}
