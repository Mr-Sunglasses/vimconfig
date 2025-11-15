return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = { "lua_ls", "ts_ls", "pyright", "bashls" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Function to get the Python interpreter path
      local function get_python_path()
        local cwd = vim.fn.getcwd()
        local venv_path = cwd .. "/.venv/bin/python"
        local fallback = "/home/linuxbrew/.linuxbrew/bin/python3"

        if vim.fn.executable(venv_path) == 1 then
          return venv_path
        end

        return fallback
      end

      -- Setup LSP servers using vim.lsp.config
      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("ts_ls", {
        capabilities = capabilities,
      })

      vim.lsp.config("pyright", {
        capabilities = capabilities,
        settings = {
          python = {
            pythonPath = get_python_path(),
          },
        },
      })

      vim.lsp.config("bashls", {
        capabilities = capabilities,
      })

      -- Apply the configuration
      vim.lsp.enable("lua_ls")
      vim.lsp.enable("ts_ls")
      vim.lsp.enable("pyright")
      vim.lsp.enable("bashls")

      -- Keymaps
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}

