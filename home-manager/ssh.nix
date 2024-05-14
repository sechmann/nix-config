{ config, ... }:
{
  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    includes = [
      (config.lib.file.mkOutOfStoreSymlink config.home.homeDirectory + ".ssh/extra_config")
    ];
  };
}
