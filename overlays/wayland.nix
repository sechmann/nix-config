let
  version = "0.1.1";
  sha256 = "sha256-AMP3VcmNWeHdpl2gECF4FDZlEcZAmZfgr5zdTNtlqt8=";
  vendorSha256 = "sha256-Y77oNc6z576Gex1lgrvNybJBxwRd0/Gtc+EiQqBikas=";
in
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
      version = version;
      src = final.pkgs.fetchFromGitHub {
        owner = "piqoni";
        repo = "hn-text";
        rev = "v${version}";
        sha256 = sha256;
      };
      vendorHash = vendorSha256;
    };
  }
