{...}: {
  plugins.harpoon = {
    enable = true;
    enableTelescope = true;
    keymaps = {
      addFile = "<leader>ha";
      cmdToggleQuickMenu = "";
      toggleQuickMenu = "<leader>ht";
      navFile = {
        "1" = "<C-1>";
        "2" = "<C-2>";
        "3" = "<C-3>";
        "4" = "<C-4>";
      };
      navNext = "<C-j>";
      navPrev = "<C-k>";
    };
  };
}
