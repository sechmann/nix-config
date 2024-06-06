{...}: {
  plugins.telescope = {
    enable = true;
    keymaps = {
      "<leader>?" = {
        action = "oldfiles";
        #desc = "[?] Find recently opened files";
      };
      "<leader><space>" = {
        action = "buffers";
        #desc = "[ ] Find existing buffers";
      };
      "<leader>/" = {
        action = "current_buffer_fuzzy_find";
        #desc = "[/] Fuzzily search in current buffer]";
      };
      "<leader>ff" = {
        action = "find_files";
        #desc = "[f]ind [f]iles";
      };
      "<leader>fh" = {
        action = "help_tags";
        #desc = "[f]find [h]elp";
      };
      "<leader>fg" = {
        action = "live_grep";
        #desc = "[f]ind by [w]ord/[g]rep";
      };
      "<leader>fw" = {
        action = "live_grep";
        #desc = "[f]ind by [w]ord/[g]rep";
      };
      "<leader>fd" = {
        action = "diagnostics";
        #desc = "[f]ind [d]iagnotics";
      };
      "<leader>fk" = {
        action = "keymaps";
        #desc = "[f]ind [k]eymaps";
      };
    };
  };
}
