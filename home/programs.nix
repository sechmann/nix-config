{
  pkgs,
  inputs,
  config,
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
      #zed-editor
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      aiven-client
      azure-cli
      bitwarden-cli
      brightnessctl
      btop
      curl
      docker
      docker-compose
      droidcam
      ethtool
      eza
      fd
      feh
      file
      firefox
      fzf
      gawk
      gnupg
      gnused
      gnutar
      google-cloud-sql-proxy
      grim
      iftop
      imagemagick
      iotop
      jq
      kanshi
      kickoff
      kubectl
      kubelogin
      kubernetes-helm
      kubeswitch
      libinput
      libreoffice-fresh
      lm_sensors
      lsof
      mpv
      networkmanagerapplet
      nh
      nix-output-monitor
      oath-toolkit
      p7zip
      pamixer
      pavucontrol
      pciutils
      playerctl
      powertop
      pwvucontrol
      ripgrep
      signal-desktop
      slack
      slurp
      spotify
      stern
      strace
      sysstat
      terraform
      thunderbird
      tree
      unzip
      upower
      usbutils
      v4l-utils
      wget
      which
      wireguard-tools
      wl-clipboard
      xxd
      xz
      yq-go
      yt-dlp
      zip
      zoom-us
    ]);

  services.mako = {
    enable = false;
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
      enable = false;
      # package = inputs.wezterm.packages."${system}".default;
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
