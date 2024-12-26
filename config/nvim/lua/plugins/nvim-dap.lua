return {
  'mfussenegger/nvim-dap',
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = {"nvim-neotest/nvim-nio"}, opts = {} }
  },
  keys = {
    { '<leader>dl', '<cmd>DapContinue<cr>' },
    { '<leader>dr', '<cmd>DapRunLast<cr>' },
    { '<leader>dJ', '<cmd>DapStepInto<cr>' },
    { '<leader>dj', '<cmd>DapStepOver<cr>' },
    { '<leader>db', '<cmd>DapToggleBreakpoint<cr>' },
  },
  config = function()
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
  end
}
