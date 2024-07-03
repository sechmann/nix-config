{
  config,
  pkgs,
  ...
}: {
  boot.extraModulePackages = [config.boot.kernelPackages.v4l2loopback];
  boot.kernelModules = ["v4l2loopback"];
  # security.polkit.extraConfig = ''
  #    polkit.addRule(function(action, subject) {
  #       if (action.id == "org.freedesktop.policykit.exec" &&
  #           action.lookup("program") == "/run/current-system/sw/bin/modprobe" &&
  #           subject.isInGroup("users")) {
  #           return polkit.Result.YES;
  #       }
  #   });
  # '';
  environment.systemPackages = with pkgs; [obs-studio];
}
