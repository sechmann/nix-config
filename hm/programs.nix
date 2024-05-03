{
  pkgs,
  inputs,
  ...
}: let
  neovimconfig = import ./nixvim;
  nvim = inputs.nixvim.legacyPackages.x86_64-linux.makeNixvimWithModule {
    inherit pkgs;
    module = neovimconfig;
  };
in {
  imports = [
    ./tmux.nix
    ./git.nix
  ];
  home.packages = with pkgs; [
    nvim
    btop
    btop
    ethtool
    eza
    file
    firefox
    fzf
    gawk
    gnupg
    gnused
    gnutar
    iftop
    iotop
    jq
    ldns
    lm_sensors
    lsof
    ltrace
    nix-output-monitor
    p7zip
    pciutils
    ripgrep
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
    zip
    zoom-us
    pavucontrol
    kubectl
    yt-dlp
    mpv
  ];

  home.shellAliases = {
    base64 = "base64 --wrap=0";
    dc = "docker compose";
    froom = "xdg-open \"zoommtg://zoom.us/join?action=join&confno=4267640733&pwd=nais\"";
    g = "git";
    gi = "git";
    k = "kubectl";
    l = "eza --long --group --all";
    listening = "sudo lsof -PiTCP -sTCP:LISTEN";
    ls = "eza --color=always --long --git --no-filesize --icons --no-time --no-permissions --no-user";
    s = "git s";
    show_cert = "openssl x509 -noout -text -in";
    t = "tmux";
    tf = "terraform";
  };

  programs = {
    fzf = {
      enable = true;
    };

    zsh = {
      enable = true;
      defaultKeymap = "viins";
      syntaxHighlighting.enable = true;
      history = {
        ignoreSpace = true;
      };
    };

    direnv = {
      enable = true;
    };

    wezterm = {
      enable = true;
      extraConfig = ''
        local wezterm = require 'wezterm'

        local config = {
        	enable_wayland = true,
        	color_scheme = 'Gruvbox Dark (Gogh)',
          -- font = wezterm.font_with_fallback { { family = 'IntelOne Mono' }, { family = 'codicon' } },
        	window_decorations = 'NONE',
        	use_resize_increments = true,
        	hide_tab_bar_if_only_one_tab = true,
        	initial_rows = 50,
        	initial_cols = 170,
        	window_padding = {
        		left = 0,
        		right = 0,
        		top = 0,
        		bottom = 0,
        	},
        }

        return config
      '';
    };

    # Let Home Manager install and manage itself.
    home-manager.enable = true;
    # ...
  };
}
