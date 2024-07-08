{...}: {
  plugins.refactoring = {
    enable = true;
    enableTelescope = true;
  };

  extraConfigLua = ''
    vim.keymap.set(
      {"n", "x"},
      "<leader>rr",
      function() require('telescope').extensions.refactoring.refactors() end
    )
  '';
}
