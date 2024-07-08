{...}: {
  colorschemes.gruvbox.enable = true;
  clipboard.register = "unnamedplus";

  globals = {
    mapleader = " ";
  };

  opts = {
    foldlevelstart = 99;
    number = true;
    relativenumber = true;
    scrolloff = 8;
    signcolumn = "yes";
    termguicolors = true;
    updatetime = 50;
    wrap = false;

    shiftwidth = 2;
    smartindent = true;
    smarttab = true;
    tabstop = 2;

    backup = false; # Undotree
    swapfile = false; # Undotree
    undofile = true;

    hlsearch = false;
    ignorecase = true;
    incsearch = true;
    smartcase = true;
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
  extraConfigLua = builtins.readFile ./lua/statusline.lua;
}
