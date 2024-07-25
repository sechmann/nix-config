{
  pkgs,
  inputs,
  config,
  system,
  ...
}: let
  nvim = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
    inherit pkgs;
    module = import ./nixvim;
  };
in {
  home.packages =
    [nvim]
    ++ (with pkgs; [
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      adriconf
      azure-cli
      bitwarden-cli
      brightnessctl
      btop
      btop
      droidcam
      ethtool
      eza
      fd
      feh
      file
      firefox
      flameshot
      fzf
      gawk
      gnupg
      gnused
      gnutar
      google-chrome
      iftop
      imagemagick
      iotop
      jq
      kanshi
      kickoff
      kitty
      kubectl
      kubelogin
      kubeswitch
      ladybird
      ldns
      lix
      lm_sensors
      lsof
      ltrace
      lynx
      mpv
      nix-output-monitor
      overmind
      p7zip
      pamixer
      pavucontrol
      pciutils
      playerctl
      powertop
      quickemu
      quickgui
      ripgrep
      signal-desktop
      slack
      spotify
      sqlitebrowser
      strace
      swappy
      sysstat
      terraform
      thunderbird
      tree
      unzip
      usbutils
      weechat
      which
      xz
      yq-go
      yt-dlp
      zed-editor
      zip
      zoom-us
    ]);

  services.mako = {
    backgroundColor = "#285577BB";
    defaultTimeout = 5000;
  };

  programs = {
    texlive = {
      enable = true;
      extraPackages = tpkgs: {inherit (tpkgs) collection-basic;};
    };
    fzf = {
      enable = true;
    };

    keychain = {
      enable = true;
      keys = [
        (config.home.homeDirectory + "/.ssh/id_ed25519")
        (config.home.homeDirectory + "/.ssh/google_compute_engine")
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    wezterm = {
      enable = true;
      package = inputs.wezterm.packages."${system}".default;
      extraConfig = ''
        return {
          enable_wayland = true,
          color_scheme = 'Gruvbox Dark (Gogh)',
          -- font = wezterm.font_with_fallback { { family = 'IntelOne Mono' }, { family = 'codicon' } },
          window_decorations = 'NONE',
          use_resize_increments = true,
          hide_tab_bar_if_only_one_tab = true,
          term = 'wezterm',
          window_padding = {
            left = 0,
            right = 0,
            top = 0,
            bottom = 0,
          },
        }
      '';
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # ...
  };
}
