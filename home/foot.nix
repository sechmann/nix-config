{...}: {
  programs.foot = {
    enable = true;
    server.enable = true;
    settings = {
      main = {
        font = "Source Code Pro:size=12";
      };

      mouse = {
        hide-when-typing = "yes";
      };
    };
  };
}
