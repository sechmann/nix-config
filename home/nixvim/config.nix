{...}: {
  colorschemes.gruvbox.enable = true;
  clipboard.register = "unnamedplus";

  globals = {
    mapleader = " ";
  };

  opts = {
    number = true;
    relativenumber = true;
    shiftwidth = 2;
    tabstop = 2;
    wrap = false;
    swapfile = false; # Undotree
    backup = false; # Undotree
    undofile = true;
    hlsearch = false;
    incsearch = true;
    termguicolors = true;
    scrolloff = 8;
    signcolumn = "yes";
    updatetime = 50;
    foldlevelstart = 99;
  };

  keymaps = [
    {
      key = "]q";
      action = "<cmd>cnext<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Quickfix next";
      };
    }
    {
      key = "[q";
      action = "<cmd>cprevious<CR>";
      options = {
        silent = true;
        noremap = true;
        desc = "Quickfix previous";
      };
    }
  ];
}
