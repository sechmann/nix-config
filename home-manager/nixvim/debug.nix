{...}: {
  plugins.dap = {
    enable = true;
    extensions = {
      dap-go = {
        enable = true;
      };
      dap-ui = {
        enable = true;
      };
    };
  };
}
