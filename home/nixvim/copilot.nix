{helpers, ...}: let
  lua = helpers.mkRaw;
in {
  plugins.copilot-vim = {
    enable = true;
  };
  keymaps = [
    {
      key = "<C-Tab>";
      action = lua ''copilot#Accept("\\<CR>")'';
      options = {
        silent = true;
        noremap = true;
        desc = "Copilot accept suggestion";
      };
    }
  ];
  extraConfigLua = ''
    let g:copilot_no_tab_map = true
  '';
}
