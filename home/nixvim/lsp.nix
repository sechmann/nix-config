{...}: {
  plugins = {
    lspsaga = {
      enable = true;
    };

    lsp = {
      enable = true;
      servers = {
        yamlls = {
          enable = true;
          settings = {
            yaml = {
              schemas = {
                "https://json.schemastore.org/github-workflow.json" = "/.github/workflows/*";
              };
            };
          };
        };
        rust_analyzer = {
          enable = true;
          installCargo = false;
          installRustc = false;
        };
        #nil-ls.enable = true;
        kotlin_language_server.enable = true;
        nixd.enable = true;
        elmls.enable = true;
        gleam.enable = true;
        gopls = {
          enable = true;
          settings = {
            gopls = {
              gofumpt = true;
              codelenses = {
                test = true;
              };
              completeUnimported = true;
              usePlaceholders = false;
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
