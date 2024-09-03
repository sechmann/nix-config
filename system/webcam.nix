{pkgs, ...}: let
  webcam-settings = pkgs.writeShellScript "webcam-settings" (builtins.readFile ./scripts/webcam-settings.sh);
in {
  services.udev.extraRules = ''
    ATTRS{idVendor}=="046d", ATTRS{idProduct}=="08e5", RUN+="${webcam-settings}"
  '';
}
