{pkgs, ...}: {
  services.udev.extraRules = ''
    SUBSYSTEM=="video4linux", KERNEL=="video[0-9]*", ATTR{index}=="0", ATTRS{idVendor}=="046d", ATTRS{idProduct}=="08e5", RUN+="${pkgs.v4l-utils}/bin/v4l2-ctl -d $devnode --set-ctrl 'focus_automatic_continuous=0'; ${pkgs.v4l-utils}/bin/v4l2-ctl -d $devnode --set-ctrl 'focus_absolute=0'"
  '';
}
