{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.custom.programs.zen-browser;
in {
  options.custom.programs.zen-browser = {
    enable = lib.mkEnableOption "Zen Browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [pkgs.zen-browser-bin];

    #home.file.".zen/profiles.ini".text = lib.generators.toINI {} {
    #  General = {
    #    StartWithLastProfile = 1;
    #    Version = 2;
    #  };

    #  Profile0 = {
    #    Name = "Default";
    #    Path = "default";
    #    IsRelative = 1;
    #    ZenAvatarPath = "chrome://browser/content/zen-avatars/avatar-32.svg";
    #    Default = 1;
    #  };
    #};
    #home.file.".zen/default/extensions" = {
    #  source = let
    #    env = pkgs.buildEnv {
    #      name = "zen-extensions";
    #      paths = with pkgs.firefoxAddons; [
    #        bitwarden
    #        consent-o-matic
    #        ether-metamask
    #        ghostery
    #        refined-github-
    #        sponsorblock
    #        tampermonkey
    #        ublock-origin
    #        youtube-shorts-block
    #      ];
    #    };
    #  in "${env}/share/mozilla/extensions/{ec8030f7-c20a-464f-9b0e-13a3a9e97384}";
    #  recursive = true;
    #  force = true;
    #};
  };
}
