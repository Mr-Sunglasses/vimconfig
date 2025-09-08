---@class LspConfig
---@field capabilities table
---@field before_init function
---@field settings table

---@diagnostic disable: missing-fields

local M = {}

---Get Python interpreter path with venv support
---@return string
local function get_python_path()
  local cwd = vim.fn.getcwd()
  local venv_path = cwd .. "/.venv/bin/python"
  local fallback = "/home/linuxbrew/.linuxbrew/bin/python3"

  if vim.fn.executable(venv_path) == 1 then
    return venv_path
  end

  return fallback
end

---Setup LSP configurations for various languages
---@param capabilities table LSP capabilities from cmp_nvim_lsp
local function setup_lsp_servers(capabilities)
  local lspconfig = require("lspconfig")

  -- Lua Language Server
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
    settings = {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          library = vim.api.nvim_get_runtime_file("", true),
        },
        telemetry = {
          enable = false,
        },
      },
    },
  })

  -- TypeScript Language Server
  lspconfig.ts_ls.setup({
    capabilities = capabilities,
  })

  -- Python Language Server (Pyright)
  lspconfig.pyright.setup({
    capabilities = capabilities,
    before_init = function(_, config)
      config.settings = config.settings or {}
      config.settings.python = config.settings.python or {}
      config.settings.python.pythonPath = get_python_path()
    end,
    settings = {
      python = {
        analysis = {
          typeCheckingMode = "strict",
          autoSearchPaths = true,
          useLibraryCodeForTypes = true,
          diagnosticMode = "workspace",
        },
      },
    },
  })

  -- Ruff Language Server (Python linting & formatting)
  -- Replaces: black, isort, flake8, and ruff_lsp
  lspconfig.ruff.setup({
    capabilities = capabilities,
    settings = {
      -- Enable both linting and formatting
      organizeImports = true,
      fixAll = true,
      -- Configuration for Python code style and linting
      lint = {
        enable = true,
        -- Ignore common non-critical issues
        ignore = {
          "E501",  -- Line too long
          "E402",  -- Module level import not at top of file
        },
        -- Focus on important rule categories
        select = {
          "E",     -- pycodestyle errors
          "W",     -- pycodestyle warnings
          "F",     -- Pyflakes
          "I",     -- isort
          "B",     -- flake8-bugbear
          "C4",    -- flake8-comprehensions
          "UP",    -- pyupgrade
        },
      },
      format = {
        enable = true,
        -- Use ruff's formatting (replaces black)
        lineLength = 88,  -- Match black's default
      },
    },
  })

  -- Bash Language Server
  lspconfig.bashls.setup({
    capabilities = capabilities,
  })

  -- C/C++ Language Server (clangd)
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

  -- Rust Language Server
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

  -- Go Language Server
  lspconfig.gopls.setup({
    capabilities = capabilities,
  })
end

---Setup LSP keymaps
local function setup_keymaps()
  -- LSP navigation
  vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Show hover documentation" })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  vim.keymap.set("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  vim.keymap.set("n", "gr", vim.lsp.buf.references, { desc = "Go to references" })
  vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, { desc = "Go to type definition" })
  
  -- LSP actions
  vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, { desc = "Code actions" })
  vim.keymap.set("n", "<leader>cr", vim.lsp.buf.rename, { desc = "Rename symbol" })
  vim.keymap.set("n", "<leader>cf", vim.lsp.buf.format, { desc = "Format code" })
  
  -- Diagnostics
  vim.keymap.set("n", "<leader>cd", vim.diagnostic.open_float, { desc = "Show diagnostics" })
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
end

---Setup auto-formatting for Python files
local function setup_auto_format()
  local auto_format_enabled = true
  
  ---Toggle auto-formatting on/off
  local function toggle_auto_format()
    auto_format_enabled = not auto_format_enabled
    local status = auto_format_enabled and "enabled" or "disabled"
    vim.notify("Python auto-formatting " .. status, vim.log.levels.INFO)
  end
  
  ---Manual format command
  local function format_current_buffer()
    local bufnr = vim.api.nvim_get_current_buf()
    local ft = vim.api.nvim_buf_get_option(bufnr, "filetype")
    
    if ft ~= "python" then
      vim.notify("Auto-format only works for Python files", vim.log.levels.WARN)
      return
    end
    
    vim.lsp.buf.format({ bufnr = bufnr })
    vim.notify("Python file formatted", vim.log.levels.INFO)
  end
  
  ---Setup auto-formatting autocommands
  local function setup_autocmds()
    local augroup = vim.api.nvim_create_augroup("PythonAutoFormat", { clear = true })
    
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      pattern = "*.py",
      callback = function(opts)
        if not auto_format_enabled then
          return
        end
        
        local bufnr = opts.buf
        local clients = vim.lsp.get_active_clients({ bufnr = bufnr })
        
        -- Check if we have a Python LSP client that supports formatting
        local has_formatter = false
        for _, client in ipairs(clients) do
          if client.name == "ruff" and client.supports_method("textDocument/formatting") then
            has_formatter = true
            break
          end
        end
        
        if has_formatter then
          vim.lsp.buf.format({ bufnr = bufnr, async = false })
        end
      end,
      desc = "Auto-format Python files on save",
    })
  end
  
  ---Setup user commands
  local function setup_commands()
    vim.api.nvim_create_user_command("PythonFormatToggle", toggle_auto_format, {
      desc = "Toggle Python auto-formatting on save",
    })
    
    vim.api.nvim_create_user_command("PythonFormat", format_current_buffer, {
      desc = "Manually format current Python buffer",
    })
    
    vim.api.nvim_create_user_command("PythonFormatEnable", function()
      auto_format_enabled = true
      vim.notify("Python auto-formatting enabled", vim.log.levels.INFO)
    end, {
      desc = "Enable Python auto-formatting on save",
    })
    
    vim.api.nvim_create_user_command("PythonFormatDisable", function()
      auto_format_enabled = false
      vim.notify("Python auto-formatting disabled", vim.log.levels.INFO)
    end, {
      desc = "Disable Python auto-formatting on save",
    })
  end
  
  ---Setup keymaps for auto-formatting
  local function setup_auto_format_keymaps()
    vim.keymap.set("n", "<leader>af", toggle_auto_format, { 
      desc = "Toggle Python auto-format" 
    })
    
    vim.keymap.set("n", "<leader>aF", format_current_buffer, { 
      desc = "Format Python buffer" 
    })
    
    vim.keymap.set("n", "<leader>ae", function()
      auto_format_enabled = true
      vim.notify("Python auto-formatting enabled", vim.log.levels.INFO)
    end, { 
      desc = "Enable Python auto-format" 
    })
    
    vim.keymap.set("n", "<leader>ad", function()
      auto_format_enabled = false
      vim.notify("Python auto-formatting disabled", vim.log.levels.INFO)
    end, { 
      desc = "Disable Python auto-format" 
    })
  end
  
  -- Initialize all auto-formatting features
  setup_autocmds()
  setup_commands()
  setup_auto_format_keymaps()
  
  -- Start with auto-formatting enabled
  auto_format_enabled = true
  vim.notify("Python auto-formatting initialized", vim.log.levels.INFO)
end

return {
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        automatic_installation = true,
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()
      setup_lsp_servers(capabilities)
      setup_keymaps()
      setup_auto_format()
    end,
  },
}