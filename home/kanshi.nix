{pkgs, ...}: {
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
            status = "enable";
          }
          {
            criteria = "eDP-1";
            status = "disable";
          }
        ];
      }
    ];
  };
}
