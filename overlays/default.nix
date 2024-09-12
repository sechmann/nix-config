{inputs, ...}: let
  zoom-pipewire = inputs.nixpkgs-zoom.legacyPackages."x86_64-linux".pipewire;
in {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      pyproject-nix = inputs.pyproject-nix;
    };
  modifications = final: prev: {
    zoom-us =
      (prev.zoom-us.override {
        pipewire = zoom-pipewire;
      })
      #prev.zoom-us
      .overrideAttrs (oldAttrs: rec {
        version = "6.0.10.5325";
        #version = "6.1.6.1013";
        src = prev.fetchurl {
          url = "https://zoom.us/client/${version}/zoom_x86_64.pkg.tar.xz";
          hash = "sha256-EStiiTUwSZFM9hyYXHDErlb0m6yjRwNl7O7XLXtkvjI=";
          #hash = "sha256-mvCJft0suOxnwTkWWuH9OYKHwTMWx61ct10P5Q/EVBM=";
        };
        # postFixup =
        #   oldAttrs.postFixup
        #   + ''
        #     wrapProgram $out/bin/zoom-us --unset XDG_SESSION_TYPE --unset WAYLAND_DISPLAY
        #     wrapProgram $out/bin/zoom --unset XDG_SESSION_TYPE --unset WAYLAND_DISPLAY
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

    # pipewire = prev.pipewire.overrideAttrs (oldAttrs: rec {
    #   version = "1.2.1";
    #   src = prev.fetchFromGitLab {
    #     domain = "gitlab.freedesktop.org";
    #     owner = "pipewire";
    #     repo = "pipewire";
    #     rev = version;
    #     sha256 = "sha256-CkxsVD813LbWpuZhJkNLJnqjLF6jmEn+CajXb2XTCsY=";
    #   };
    # });
  };
}
