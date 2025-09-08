return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      
      -- Python debugging configuration
      dap.adapters.python = {
        type = "executable",
        command = "python",
        args = { "-m", "debugpy.adapter" },
      }
      
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            local venv_path = cwd .. "/.venv/bin/python"
            local fallback = "python3"
            
            if vim.fn.executable(venv_path) == 1 then
              return venv_path
            end
            
            return fallback
          end,
          console = "integratedTerminal",
          justMyCode = true,
        },
        {
          type = "python",
          request = "attach",
          name = "Attach remote",
          host = "localhost",
          port = 5678,
          mode = "remote",
        },
        {
          type = "python",
          request = "launch",
          name = "Launch module",
          module = function()
            return vim.fn.input("Module name: ")
          end,
          pythonPath = function()
            local cwd = vim.fn.getcwd()
            local venv_path = cwd .. "/.venv/bin/python"
            local fallback = "python3"
            
            if vim.fn.executable(venv_path) == 1 then
              return venv_path
            end
            
            return fallback
          end,
          console = "integratedTerminal",
        },
      }
      
      -- DAP keymaps
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Toggle breakpoint" })
      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Continue debugging" })
      vim.keymap.set("n", "<leader>do", dap.step_over, { desc = "Step over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Step into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Step out" })
      vim.keymap.set("n", "<leader>dr", dap.repl.toggle, { desc = "Toggle REPL" })
      vim.keymap.set("n", "<leader>dl", dap.run_last, { desc = "Run last configuration" })
      vim.keymap.set("n", "<leader>dC", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Set conditional breakpoint" })
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "scopes", size = 0.25 },
              { id = "breakpoints", size = 0.25 },
              { id = "stacks", size = 0.25 },
              { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
          },
          {
            elements = {
              { id = "repl", size = 1.0 },
            },
            size = 10,
            position = "bottom",
          },
        },
      })
      
      vim.keymap.set("n", "<leader>du", function()
        require("dapui").toggle()
      end, { desc = "Toggle DAP UI" })
      
      vim.keymap.set("n", "<leader>de", function()
        require("dapui").eval()
      end, { desc = "Evaluate expression" })
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-neotest/neotest-python",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local neotest = require("neotest")
      neotest.setup({
        adapters = {
          require("neotest-python")({
            dap = {
              justMyCode = false,
              console = "integratedTerminal",
            },
            args = { "--log-level", "DEBUG" },
            runner = "pytest",
          }),
        },
      })
      
      -- Test keymaps
      vim.keymap.set("n", "<leader>tt", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run current file tests" })
      
      vim.keymap.set("n", "<leader>tn", function()
        neotest.run.run()
      end, { desc = "Run nearest test" })
      
      vim.keymap.set("n", "<leader>tf", function()
        neotest.run.run(vim.fn.expand("%"))
      end, { desc = "Run current file tests" })
      
      vim.keymap.set("n", "<leader>ts", function()
        neotest.summary.toggle()
      end, { desc = "Toggle test summary" })
      
      vim.keymap.set("n", "<leader>to", function()
        neotest.output.open({ enter = true })
      end, { desc = "Open test output" })
      
      vim.keymap.set("n", "<leader>tO", function()
        neotest.output_panel.toggle()
      end, { desc = "Toggle test output panel" })
      
      vim.keymap.set("n", "<leader>tS", function()
        neotest.run.stop()
      end, { desc = "Stop test" })
    end,
  },
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")
      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = {
              command = { "python3" },
            },
          },
          repl_open_cmd = "vertical botright 80 split",
        },
        keymaps = {
          send_motion = "<leader>rc",
          visual_send = "<leader>rc",
          send_file = "<leader>rf",
          send_line = "<leader>rl",
          send_mark = "<leader>rm",
          mark_motion = "<leader>rm",
          mark_visual = "<leader>rm",
          remove_mark = "<leader>rmd",
          cr = "<leader>r<cr>",
          interrupt = "<leader>r<space>",
          exit = "<leader>rq",
          clear = "<leader>rx",
        },
      })
    end,
  },
  -- Auto-formatting for Python files is included in auto-format-wrapper.lua
  {
    "folke/which-key.nvim",
    config = function()
      local wk = require("which-key")
      
      wk.add({
        { "<leader>d", group = "Debug" },
        { "<leader>db", desc = "Toggle breakpoint" },
        { "<leader>dc", desc = "Continue" },
        { "<leader>do", desc = "Step over" },
        { "<leader>di", desc = "Step into" },
        { "<leader>dO", desc = "Step out" },
        { "<leader>dr", desc = "REPL" },
        { "<leader>dl", desc = "Run last" },
        { "<leader>dC", desc = "Conditional breakpoint" },
        { "<leader>du", desc = "Toggle UI" },
        { "<leader>de", desc = "Evaluate expression" },
        
        { "<leader>t", group = "Test" },
        { "<leader>tt", desc = "Run current file tests" },
        { "<leader>tn", desc = "Run nearest test" },
        { "<leader>tf", desc = "Run current file tests" },
        { "<leader>ts", desc = "Toggle test summary" },
        { "<leader>to", desc = "Open test output" },
        { "<leader>tO", desc = "Toggle test output panel" },
        { "<leader>tS", desc = "Stop test" },
        
        { "<leader>r", group = "REPL" },
        { "<leader>rc", desc = "Send to REPL" },
        { "<leader>rf", desc = "Send file to REPL" },
        { "<leader>rl", desc = "Send line to REPL" },
        { "<leader>rm", desc = "Mark motion" },
        { "<leader>rq", desc = "Quit REPL" },
        { "<leader>rx", desc = "Clear REPL" },
        
              })
    end,
  },
}