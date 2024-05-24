{ config, ... }:
{
  programs.eww = {
    enable = true;
    configDir = ./eww;
  };
}
