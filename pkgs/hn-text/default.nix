{
  fetchFromGitHub,
  buildGoModule,
  ...
}:
buildGoModule {
  pname = "hn-text";
  version = "0.1.3";
  src = fetchFromGitHub {
    owner = "piqoni";
    repo = "hn-text";
    rev = "v0.1.3";
    sha256 = "sha256-if+r2i3dC/rzHaih3INiAQYy5VmyGdV4XaNzwpn5XBA=";
  };
  vendorHash = "sha256-lhghteKspXK1WSZ3dVHaTgx2BRx9S7yGNbvRYZKeA+s=";
}
