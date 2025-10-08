return {
  "mfussenegger/nvim-dap",
  enabled = vim.fn.has "win32" == 0,
  dependencies = {
    { "rcarriga/nvim-dap-ui", dependencies = { "nvim-neotest/nvim-nio" } },
    { "theHamsta/nvim-dap-virtual-text", opts = {} },
    "jay-babu/mason-nvim-dap.nvim",
  },
  keys = {
    { "<Leader>du", function() require("dapui").toggle() end, desc = "Dap UI" },
    { "<Leader>de", function() require("dapui").toggle() end, desc = "Eval", mode = { "n", "v" } },
    {
      "<Leader>dB",
      function() require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ") end,
      desc = "Breakpoint Condition",
    },
    { "<Leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    { "<Leader>dc", function() require("dap").continue() end, desc = "Continue" },
    {
      "<Leader>da",
      function()
        require("dap").continue {
          before = function(config)
            local args = type(config.args) == "function" and (config.args() or {}) or config.args or {}
            config = vim.deepcopy(config)
            ---@cast args string[]
            config.args = function()
              local new_args = vim.fn.input("Run with args: ", table.concat(args, " ")) --[[@as string]]
              return vim.split(vim.fn.expand(new_args) --[[@as string]], " ")
            end
            return config
          end,
        }
      end,
      desc = "Run with Args",
    },
    { "<Leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
    { "<Leader>dg", function() require("dap").goto_() end, desc = "Go to line (no execute)" },
    { "<Leader>di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<Leader>dj", function() require("dap").down() end, desc = "Down" },
    { "<Leader>dk", function() require("dap").up() end, desc = "Up" },
    { "<Leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
    { "<Leader>do", function() require("dap").step_out() end, desc = "Step Out" },
    { "<Leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
    { "<Leader>dp", function() require("dap").pause() end, desc = "Pause" },
    { "<Leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
    { "<Leader>ds", function() require("dap").session() end, desc = "Session" },
    { "<Leader>dt", function() require("dap").terminate() end, desc = "Terminate" },
    { "<Leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
  },
  config = function()
    local dap, dapui = require "dap", require "dapui"

    dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
    dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
    dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    dapui.setup {
      floating = {
        border = "single",
      },
    }

    require("dap").adapters["codelldb"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "codelldb",
        args = {
          "--port",
          "${port}",
        },
      },
    }
    for _, lang in ipairs { "c", "cpp", "objc", "cuda", "proto" } do
      dap.configurations[lang] = {
        {
          type = "codelldb",
          request = "launch",
          name = "Launch file",
          program = function() return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file") end,
          cwd = "${workspaceFolder}",
        },
        {
          type = "codelldb",
          request = "attach",
          name = "Attach to process",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }
    end
    -- for c/c++ debugging end
  end,
}
