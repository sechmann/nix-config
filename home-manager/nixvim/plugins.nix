{ pkgs, lib, ... }:
let
  fromGitHub =
    rev: ref: repo:
    pkgs.vimUtils.buildVimPlugin {
      pname = "${lib.strings.sanitizeDerivationName repo}";
      version = ref;
      src = builtins.fetchGit {
        url = "https://github.com/${repo}.git";
        ref = ref;
        rev = rev;
      };
    };
in
{
  plugins = {
    gitsigns.enable = true;
    #oil.enable = true;
    undotree.enable = true;
    fugitive.enable = true;
    which-key.enable = true;
    copilot-vim.enable = true;
  };
  extraPackages = with pkgs; [
    # Formatters
    #alejandra
    nixfmt-rfc-style
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
  extraPlugins = [
    (fromGitHub "3cf0bf406fcbb9b442589c05b306bfe11e1d27b0" "main" "cwebster2/github-coauthors.nvim")
  ];
  extraConfigLua = ''
    require('telescope').load_extension('githubcoauthors')
    vim.keymap.set('n', '<leader>gA', require('telescope').extensions.githubcoauthors.coauthors)
  '';
}
