{
  inputs,
  nixpkgs-zoom,
  ...
}: let
in {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
      pyproject-nix = inputs.pyproject-nix;
    };
  modifications = final: prev: {
    zoom-us = nixpkgs-zoom.zoom-us;
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
