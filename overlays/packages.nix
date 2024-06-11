final: prev: {
  #zoom-us = prev.zoom-us.overrideAttrs (oldAttrs: {
  #  postFixup =
  #    oldAttrs.postFixup
  #    + ''
  #      mv $out/bin/{zoom,zoom-x11}
  #      makeWrapper $out/bin/zoom-x11 $out/bin/zoom \
  #        --unset XDG_SESSION_TYPE
  #    '';
  #});

  slack = prev.slack.overrideAttrs (oldAttrs: {
    installPhase =
      oldAttrs.installPhase
      + ''
        mv $out/bin/{slack,slack-x11}
        makeWrapper $out/bin/slack-x11 $out/bin/slack \
          --add-flags "--enable-features=WebRTCPipeWireCapturer"
      '';
  });

  hn-text = final.pkgs.buildGoModule {
    pname = "hn-text";
    version = "0.1.3";
    src = final.pkgs.fetchFromGitHub {
      owner = "piqoni";
      repo = "hn-text";
      rev = "v0.1.3";
      sha256 = "sha256-if+r2i3dC/rzHaih3INiAQYy5VmyGdV4XaNzwpn5XBA=";
    };
    vendorHash = "sha256-lhghteKspXK1WSZ3dVHaTgx2BRx9S7yGNbvRYZKeA+s=";
  };
}
