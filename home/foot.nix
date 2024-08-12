{...}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Source Code Pro:size=12,Font Awesome 6 Free:size=12,Font Awesome 6 Brands:size=12";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
