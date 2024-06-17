{helpers, ...}: let
  lua = helpers.mkRaw;
in {
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
  keymaps = [
    {
      key = "<leader>b";
      action = lua ''require("dap").toggle_breakpoint'';
      options = {
        silent = true;
        noremap = true;
        desc = "Toggle [b]reakpoint";
      };
    }
    {
      key = "<leader>B";
      action = lua ''require("dap").list_breakpoints'';
      options = {
        silent = true;
        noremap = true;
        desc = "List [B]reakpoint";
      };
    }
    {
      key = "<leader>dc";
      action = lua ''require("dap").continue'';
      options = {
        silent = true;
        noremap = true;
        desc = "List [d]debugger [c]ontinue";
      };
    }
  ];
  extraConfigLua = ''
    -- dap / dap-ui extra config
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.before.attach.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.launch.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  '';
}
