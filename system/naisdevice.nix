{ pkgs, ... }:
{
  services.naisdevice.enable = true;
  environment.systemPackages = [ pkgs.naisdevice ];
}
