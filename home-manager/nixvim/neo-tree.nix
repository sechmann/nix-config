{...}: {
  config = {
    plugins.neo-tree = {
      enable = true;
      closeIfLastWindow = true;
      enableRefreshOnWrite = true;
      enableGitStatus = true;
      filesystem.followCurrentFile = {
        enabled = true;
        leaveDirsOpen = false;
      };
    };
    keymaps = [
      {
        key = "<C-n>";
        action = "<cmd>Neotree toggle<CR>";
        options = {
          silent = true;
          noremap = true;
          desc = "Open Neotree";
        };
      }
    ];
  };
}
