{...}: {
  # for a list of formatters: `:help conform-formatters`
  plugins.conform-nvim = {
    enable = true;
    formattersByFt = {
      css = [
        "prettierd"
        "prettier"
      ];
      html = [
        "prettierd"
        "prettier"
      ];
      javascript = [
        "prettierd"
        "prettier"
      ];
      json = ["prettier"];
      lua = ["stylua"];
      markdown = ["prettier"];
      nix = ["alejandra"];
      python = [
        "isort"
        "black"
      ];
      rust = ["rustfmt"];
      sh = ["shfmt"];
      typescript = [
        "prettierd"
        "prettier"
      ];
      yaml = [
        "prettierd"
        "prettier"
      ];
    };
    formatters = {
      asmfmt = {
        command = "asmfmt";
        stdin = true;
      };
    };
    formatOnSave = {
      lspFallback = true;
      timeoutMs = 2000;
    };
  };

  extraConfigLuaPre = ''
    -- Formatting function for conform
    _G.format_with_conform = function()
    	local conform = require("conform")
    	conform.format({
    		lsp_fallback = true,
    		async = false,
    		timeout_ms = 2000,
    	})
    end
  '';
}
