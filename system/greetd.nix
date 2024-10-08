{
  pkgs,
  lib,
  ...
}: let
  riverRun = pkgs.writeShellScript "river-run" ''
    ${pkgs.river}/bin/river |& tee river.log
  '';
  swayRun = pkgs.writeShellScript "sway-run" ''
    export SDL_VIDEODRIVER=wayland
    export _JAVA_AWT_WM_NONREPARENTING=1
    export QT_QPA_PLATFORM=wayland
    export XDG_SESSION_TYPE=wayland
    export XDG_SESSION_DESKTOP=sway
    export XDG_CURRENT_DESKTOP=sway

    ${pkgs.sway}/bin/sway |& tee sway.log
  '';
in {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${
          lib.makeBinPath [pkgs.greetd.tuigreet]
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

  environment.etc = {
    "greetd/environments.d/river.desktop".text = ''
      [Desktop Entry]
      Name=River
      Exec=${riverRun}
    '';
    "greetd/environments.d/sway.desktop".text = ''
      [Desktop Entry]
      Name=Sway
      Exec=${swayRun}
    '';
  };
}
