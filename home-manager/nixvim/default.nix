{pkgs, ...}: {
  imports = [
    ./treesitter.nix
    ./completion.nix
    ./lsp.nix
    ./telescope.nix
    ./neo-tree.nix
    ./format.nix
  ];

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
    swapfile = false; #Undotree
    backup = false; #Undotree
    undofile = true;
    hlsearch = false;
    incsearch = true;
    termguicolors = true;
    scrolloff = 8;
    signcolumn = "yes";
    updatetime = 50;
    foldlevelstart = 99;
  };

  plugins = {
    gitsigns.enable = true;
    oil.enable = true;
    undotree.enable = true;
    fugitive.enable = true;
    nvim-tree.enable = true;
    cmp.enable = true;
    which-key.enable = true;
  };
  extraPackages = with pkgs; [
    # Formatters
    alejandra
    asmfmt
    astyle
    black
    cmake-format
    gofumpt
    golines
    gotools
    isort
    nodePackages.prettier
    prettierd
    rustfmt
    shfmt
    stylua
    # Linters
    commitlint
    eslint_d
    golangci-lint
    hadolint
    html-tidy
    luajitPackages.luacheck
    markdownlint-cli
    nodePackages.jsonlint
    pylint
    ruff
    shellcheck
    vale
    yamllint
    # Debuggers / misc deps
    asm-lsp
    bashdb
    clang-tools
    delve
    fd
    gdb
    go
    lldb_17
    llvmPackages_17.bintools-unwrapped
    marksman

    (nerdfonts.override {
      fonts = [
        "JetBrainsMono"
        "RobotoMono"
      ];
    })

    python3
    ripgrep
    rr
    tmux-sessionizer
    zig
  ];
}
