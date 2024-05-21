{ pkgs, lib, ... }:
let
  swayRun = pkgs.writeShellScript "sway-run" ''
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway

    ${pkgs.sway}/bin/sway |& tee sway.log
  '';
  hyprlandRun = pkgs.writeShellScript "hyprland-run" ''
    #export XDG_SESSION_TYPE=wayland
    #export XDG_SESSION_DESKTOP=hyprland
    #export XDG_CURRENT_DESKTOP=hyprland
    ${pkgs.hyprland}/bin/Hyprland
  '';
in
{
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${
          lib.makeBinPath [ pkgs.greetd.tuigreet ]
        }/tuigreet --time --remember --remember-session --sessions=/etc/greetd/environments.d/";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };

  environment.etc."greetd/environments.d/sway.desktop".text = ''
    [Desktop Entry]
    Name=Sway
    Exec=${swayRun}
  '';

  environment.etc."greetd/environments.d/hyprland.desktop".text = ''
    [Desktop Entry]
    Name=Hyprland
    Exec=${hyprlandRun}
  '';
}
