{...}: {
  programs = {
    git = {
      enable = true;
      userName = "Vegar Sechmann Molvig";
      userEmail = "vegar.sechmann.molvig@nav.no";
      signing = {
        key = "~/.ssh/id_ed25519";
        signByDefault = true;
      };
      attributes = ["go.sum merge=union"];
      extraConfig = {
        rebase.autoStash = true;
        init.defaultBranch = "main";
        pull.default = "current";
        pull.rebase = true;
        push.default = "current";
        push.autoSetupRemote = true;
        gpg.format = "ssh";
      };
      aliases = {
        commir = "commit";
        tpush = "push";
        co = "checkout";
        b = "branch";
        s = "status --short --branch";
        c = "commit";
        a = "add";
        dt = "difftool";
        grog = "log --graph --abbrev-commit --decorate --all --format=format:\"%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(dim white) - %an%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n %C(white)%s%C(reset)\"";
        lg = "log --graph --format=\"%C(auto)%h -%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset\"";
        p = "!sh -c \"(( $RANDOM > 16383 )) && git push || git pull\"";
        pus = "push";
      };
    };
    gh = {
      enable = true;
    };
  };
}
