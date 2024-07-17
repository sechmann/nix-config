{
  fetchFromGitHub,
  python3Packages,
}: let
  rev = "v0.1";
in
  python3Packages.buildPythonPackage {
    pname = "fido2ble-to-uhid";
    src = fetchFromGitHub {
      owner = "PoneBiometrics";
      repo = "fido2ble-to-uhid";
      rev = rev;
      sha256 = "sha256-+FeACk//JaDKPNv1GV4D4BvmSVhy9qDAqzPKY6aiJiw=";
    };
    version = rev;
  }
