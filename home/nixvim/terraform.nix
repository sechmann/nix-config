{...}: {
  plugins = {
    lsp = {
      servers = {
        terraformls.enable = true;
      };
    };
  };
  extraConfigLua = ''
    vim.filetype.add({ extension = { tf = 'terraform' } })
  '';
}
