{ inputs }:
{ ... }:
{
  environment.systemPackages = [ inputs.kolide-launcher ];

  services.kolide-launcher = {
    enable = true;
    kolideHostname = "k2.kolide.com";
    rootDirectory = "/var/kolide-k2/k2.kolide.com";
    updateChannel = "nightly";
  };
}
