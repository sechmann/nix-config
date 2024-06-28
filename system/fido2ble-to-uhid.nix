{pkgs, ...}: {
  systemd.services.fido2ble-to-uhid = {
    description = "fido2ble-to-uhid";
    wantedBy = ["multi-user.target"];
    serviceConfig.ExecStart = "${pkgs.fido2ble-to-uhid}/bin/fido2ble-to-uhid";
    serviceConfig.Restart = "always";
  };
}
