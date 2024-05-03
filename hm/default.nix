{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixvim.homeManagerModules.nixvim
    ./programs.nix
  ];
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vegar";
  home.homeDirectory = "/home/vegar";

  wayland.windowManager.sway = {
    checkConfig = false; # doesn't work with custom keyboard layout
    enable = true;
    wrapperFeatures = {
      gtk = true;
      base = true;
    };
    systemd.enable = true;
    config = {
      modifier = "Mod4";
      fonts = {
        size = 11.0;
      };
      input = {
        "type:keyboard" = {
          xkb_layout = "us-no";
        };
      };
      output = {
        DP-3 = {
          mode = "3840x2160@120.000Hz";
          pos = "0 0";
        };
      };
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

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
