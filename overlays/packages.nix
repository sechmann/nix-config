inputs: final: prev: {
  # zoom-us = prev.zoom-us.overrideAttrs (oldAttrs: {
  #   src = prev.fetchurl {
  #     url = "https://zoom.us/client/6.1.1.443/zoom_x86_64.pkg.tar.xz";
  #     hash = "sha256-2FOAZ3MKusouuWvhxFEcqX+2e+PCF4N5zaz7mc9Mnq4=";
  #   };
  #   #installPhase = ''
  #   #  mkdir $out
  #   #  tar -C $out -xf $src
  #   #  # commented out this
  #   #  #mv $out/usr/* $out/
  #   #'';
  #   postFixup =
  #     oldAttrs.postFixup
  #     + ''
  #       makeWrapper $out/bin/zoom $out/bin/zoom-fake-gnome \
  #         --set XDG_SESSION_TYPE=gnome
  #     '';
  # });

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

  customTmuxPlugins = {
    minimal-tmux = {plugin = inputs.minimal-tmux.packages.${final.pkgs.system}.default;};
  };

  fido2ble-to-uhid = let
    rev = "v0.1";
  in
    prev.pkgs.python3Packages.buildPythonPackage {
      pname = "fido2ble-to-uhid";
      src = prev.fetchFromGitHub {
        owner = "PoneBiometrics";
        repo = "fido2ble-to-uhid";
        rev = rev;
        sha256 = "sha256-+FeACk//JaDKPNv1GV4D4BvmSVhy9qDAqzPKY6aiJiw=";
      };
      version = rev;
    };
}
