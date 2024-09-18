{
  config,
  lib,
  inputs,
  system,
  ...
}: let
  cfg = config.custom.programs.zen-browser;
in {
  options.custom.programs.zen-browser = {
    enable = lib.mkEnableOption "Zen Browser";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [inputs.zen-browser.packages."${system}".specific];
  };
}
