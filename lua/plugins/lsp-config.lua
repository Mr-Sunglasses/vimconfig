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
        ensure_installed = { "lua_ls", "ts_ls", "pyright", "bashls", "clangd", "rust_analyzer" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")

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

      -- Lua LS setup
      lspconfig.lua_ls.setup({
        capabilities = capabilities,
      })

      -- TypeScript LS setup
      lspconfig.ts_ls.setup({
        capabilities = capabilities,
      })

      -- Pyright setup with .venv support
      lspconfig.pyright.setup({
        capabilities = capabilities,
        before_init = function(_, config)
          config.settings = config.settings or {}
          config.settings.python = config.settings.python or {}
          config.settings.python.pythonPath = get_python_path()
        end,
      })

      -- Bash LS setup
      lspconfig.bashls.setup({
        capabilities = capabilities,
      })

      -- Clangd setup for C/C++
      lspconfig.clangd.setup({
        capabilities = capabilities,
        cmd = {
          "clangd",
          "--background-index",
          "--clang-tidy",
          "--header-insertion=iwyu",
          "--completion-style=detailed",
          "--function-arg-placeholders",
          "--fallback-style=llvm",
        },
        init_options = {
          usePlaceholders = true,
          completeUnimported = true,
          clangdFileStatus = true,
        },
        filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
      })

      -- Rust Analyzer setup
      lspconfig.rust_analyzer.setup({
        capabilities = capabilities,
        settings = {
          ["rust-analyzer"] = {
            cargo = {
              allFeatures = true,
              loadOutDirsFromCheck = true,
              runBuildScripts = true,
            },
            checkOnSave = {
              allFeatures = true,
              command = "clippy",
              extraArgs = { "--no-deps" },
            },
            procMacro = {
              enable = true,
              ignored = {
                ["async-trait"] = { "async_trait" },
                ["napi-derive"] = { "napi" },
                ["async-recursion"] = { "async_recursion" },
              },
            },
          },
        },
      })

      -- Keymaps
      vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
      vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, {})
    end,
  },
}

