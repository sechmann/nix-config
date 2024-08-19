{pkgs}: {
  hn-text = pkgs.callPackage ./hn-text {};
  fido2ble-to-uhid = pkgs.callPackage ./fido2ble-to-uhid {};
  humanlog = pkgs.callPackage ./humanlog {};
  # borrowed from https://github.com/SonarMonkey/meninx/tree/0eb42efa8582470aed516926646e8888cfbea365/pkgs/zed-editor
  #zed-editor = pkgs.callPackage ./zed-editor {};
}
