{
  fetchFromGitHub,
  buildGoModule,
  ...
}:
buildGoModule rec {
  pname = "humanlog";
  version = "0.7.6";
  src = fetchFromGitHub {
    owner = "humanlogio";
    repo = "humanlog";
    rev = "v${version}";
    sha256 = "sha256-90IDTlt96kP4ZxR+fPv/MZ4bOlu98QcZ/ga3AKG7qJM=";
  };
  vendorHash = null; # src repo has vendor checked in
}
