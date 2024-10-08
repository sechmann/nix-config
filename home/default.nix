{inputs, ...}: {
  imports = [
    #./river.nix
    ./browser.nix
    ./dots.nix
    ./foot.nix
    ./git.nix
    ./humanlog.nix
    ./kanshi.nix
    ./lock.nix
    ./modules
    ./programs.nix
    ./ssh.nix
    ./sway.nix
    ./swaync
    ./tmux.nix
    ./waybar
    ./zed-editor.nix
    ./zsh.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
  custom.programs.zen-browser.enable = true;
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "vegar";
  home.homeDirectory = "/home/vegar";

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
