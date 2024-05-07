{...}: {
  home.shellAliases = {
    base64 = "base64 --wrap=0";
    dc = "docker compose";
    froom = "xdg-open \"zoommtg://zoom.us/join?action=join&confno=4267640733&pwd=nais\"";
    g = "git";
    gi = "git";
    k = "kubectl";
    l = "eza --long --group --all";
    listening = "sudo lsof -PiTCP -sTCP:LISTEN";
    ls = "eza --color=always --long --git --no-filesize --icons --no-time --no-permissions --no-user";
    s = "git s";
    show_cert = "openssl x509 -noout -text -in";
    t = "tmux";
    tf = "terraform";
  };

  programs.zsh = {
    enable = true;
    defaultKeymap = "viins";
    syntaxHighlighting.enable = true;
    history = {
      ignoreSpace = true;
    };
  };
}
