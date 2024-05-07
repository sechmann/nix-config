{...}: {
  plugins = {
    cmp = {
      enable = true;
      settings = {
        mapping = {
          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";
          "<C-e>" = "cmp.mapping.close()";
          "<C-space>" = "cmp.mapping.complete()";
          "<CR>" = "cmp.mapping.confirm({ select = true })";
          "<Tab>" = "cmp.mapping.select_next_item()";
          "<S-Tab>" = "cmp.mapping.select_prev_item()";
          "<Down>" = "cmp.mapping.select_next_item()";
          "<Up>" = "cmp.mapping.select_prev_item()";
        };
        snippet.expand = ''
          function(args)
            require('luasnip').lsp_expand(args.body)
          end
        '';
        sources = [
          {
            name = "nvim_lsp";
            groupIndex = 1;
          }
          {
            name = "path";
            groupIndex = 1;
          }
          {
            name = "buffer";
            groupIndex = 2;
          }
        ];
      };
    };
    cmp-buffer.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-cmdline.enable = true;
    cmp-path.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp_luasnip.enable = true;
    luasnip.enable = true;
  };

  extraConfigLua = ''
    -- Extra options for cmp-cmdline setup
    local cmp = require("cmp")
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        {
          name = "cmdline",
          option = {
            ignore_cmds = { "Man", "!" },
          },
        },
      }),
    })
  '';
}
