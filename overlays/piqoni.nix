let
  version = "0.0.1";
  sha256 = "da8982dcf200bb21e5ae214af7297187ce4707ce";
  vendorSha256 = "0m2fzpqxk7hrbxsgqplkg7h2p7gv6s1miymv3gvw0cz039skag0s";
in
final: prev: {
  hn-text = final.pkgs.buildGoModule {
    pname = "hn-text";
    version = version;
    src = final.pkgs.fetchGitHub {
      owner = "piqoni";
      repo = "hn-text";
      rev = "v${version}";
      sha256 = sha256;
    };
    vendorSha256 = vendorSha256;
  };
}
