{
  pkgs,
  lib,
  ...
}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Source Code Pro:size=12,Font Awesome 6 Free:size=12,Font Awesome 6 Brands:size=12";
        include = "${lib.getOutput "themes" pkgs.foot}/share/foot/themes/srcery";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
