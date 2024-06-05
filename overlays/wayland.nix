let
  version = "0.0.1";
  sha256 = "da8982dcf200bb21e5ae214af7297187ce4707ce";
  vendorSha256 = "0m2fzpqxk7hrbxsgqplkg7h2p7gv6s1miymv3gvw0cz039skag0s";
in
final: prev: {
  zoom-us = prev.zoom-us.overrideAttrs (oldAttrs: {
    postFixup =
      oldAttrs.postFixup
      + ''
        mv $out/bin/{zoom,zoom-x11}
        makeWrapper $out/bin/zoom-x11 $out/bin/zoom \
          --unset XDG_SESSION_TYPE
      '';
  });

  slack = prev.slack.overrideAttrs (oldAttrs: {
    installPhase =
      oldAttrs.installPhase
      + ''
        mv $out/bin/{slack,slack-x11}
        makeWrapper $out/bin/slack-x11 $out/bin/slack \
          --add-flags "--enable-features=WebRTCPipeWireCapturer"
      '';
  });

  hn-text = final.buildGoModule {
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
