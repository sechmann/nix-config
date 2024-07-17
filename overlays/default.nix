{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};
  modifications = final: prev: {
    zoom-us = prev.zoom-us.overrideAttrs (oldAttrs: rec {
      version = "6.0.10.5325";
      src = prev.fetchurl {
        url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
        hash = "sha256-EStiiTUwSZFM9hyYXHDErlb0m6yjRwNl7O7XLXtkvjI=";
      };
      # postFixup =
      #   oldAttrs.postFixup
      #   + ''
      #     makeWrapper $out/bin/zoom $out/bin/zoom-fake-gnome \
      #       --set XDG_SESSION_TYPE=gnome
      #   '';
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

    customTmuxPlugins = {
      minimal-tmux = {plugin = inputs.minimal-tmux.packages.${final.pkgs.system}.default;};
    };
  };
}
