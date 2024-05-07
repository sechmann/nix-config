{pkgs, ...}: {
  config = {
    plugins.neo-tree = {
      enable = true;
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
