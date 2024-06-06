{...}: {
  plugins = {
    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        gopls = {
          enable = true;
          settings = {
            gopls = {
              gofumpt = true;
              codelens = {
                test = true;
              };
              completeUnimported = true;
              usePlaceholders = true;
              staticcheck = true;
              # hints = { };
              analyses = {
                unusedparams = true;
                nilness = true;
                unusedwrite = true;
                useany = true;
                unusedvariable = true;
              };
            };
          };
        };
      };
      keymaps = {
        diagnostic = {
          "]d" = "goto_next";
          "[d" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
          gr = "references";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          "<leader>rn" = "rename";
          "<leader>ca" = "code_action";
        };
      };
    };
  };
}
