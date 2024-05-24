{ pkgs, ... }:
{

  # dependencies for eww
  home.packages = with pkgs; [
    bash
    gawk
    coreutils # for `stdbuf` and `seq`
    gnugrep
    socat
    jq
    python3
  ];
  programs.eww = {
    enable = true;
    configDir = ./eww;
  };
}
