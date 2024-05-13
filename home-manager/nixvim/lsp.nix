{...}: {
  plugins = {
    lsp = {
      enable = true;
      servers = {
        nixd.enable = true;
        gopls = {
          enable = true;
          extraOptions = {
            formatting.gofumpt = true;
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
          gD = "references";
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
