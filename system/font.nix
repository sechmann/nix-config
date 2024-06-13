{
  lib,
  pkgs,
  ...
}: {
  console = {
    font = "ter-124b";
    keyMap = lib.mkDefault "us";
    useXkbConfig = true; # use xkb.options in tty.
    packages = with pkgs; [terminus_font];
  };
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      corefonts # Microsoft free fonts
      dejavu_fonts
      fira
      fira-mono
      font-awesome
      google-fonts
      inconsolata # monospaced
      libertine
      line-awesome
      mononoki
      nerdfonts
      nerdfonts
      open-dyslexic
      overpass
      oxygenfonts
      powerline-fonts
      source-code-pro
      source-sans-pro
      source-serif-pro
      ttf_bitstream_vera
      ubuntu_font_family # Ubuntu fonts
      unifont # some international languages
    ];
    fontconfig = {
      antialias = true;
      cache32Bit = true;
      hinting.enable = true;
      hinting.autohint = true;
      defaultFonts = {
        monospace = ["Source Code Pro"];
        sansSerif = ["Source Sans Pro"];
        serif = ["Source Serif Pro"];
      };
    };
  };
}
