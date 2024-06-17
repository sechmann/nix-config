{
  pkgs,
  inputs,
  config,
  system,
  ...
}: let
  neovimconfig = import ./nixvim;
  nvim = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
in {
  imports = [
    ./git.nix
    ./ssh.nix
    ./tmux.nix
    ./zsh.nix
  ];
  home.packages =
    [nvim]
    ++ (with pkgs; [
      (google-cloud-sdk.withExtraComponents [google-cloud-sdk.components.gke-gcloud-auth-plugin])
      adriconf
      azure-cli
      brightnessctl
      btop
      btop
      ethtool
      eza
      fd
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
      iotop
      jq
      kanshi
      kickoff
      kitty
      kubectl
      kubelogin
      kubeswitch
      ldns
      lix
      lm_sensors
      lsof
      ltrace
      mpv
      nix-output-monitor
      obs-studio
      overmind
      p7zip
      pamixer
      pavucontrol
      pciutils
      playerctl
      ripgrep
      signal-desktop
      slack
      spotify
      strace
      sysstat
      tree
      unzip
      usbutils
      which
      xz
      yq-go
      yt-dlp
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
