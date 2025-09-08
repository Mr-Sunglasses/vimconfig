---@class MasonToolsConfig
---@field ensure_installed table
---@field auto_update boolean
---@field run_on_start boolean

return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = { "williamboman/mason.nvim" },
  config = function()
    require("mason-tool-installer").setup({
      ---@type table List of tools to automatically install
      ensure_installed = {
        -- Language Servers (LSP)
        "lua_ls",      -- Lua
        "ts_ls",       -- TypeScript/JavaScript
        "pyright",     -- Python type checking and IntelliSense
        "ruff",        -- Python linting and formatting (replaces black, isort, flake8)
        "bashls",      -- Bash
        "clangd",      -- C/C++
        "rust_analyzer",-- Rust
        "gopls",       -- Go
        
        -- Additional Linters
        "flake8",      -- Python style guide enforcement (complementary to ruff)
        "mypy",        -- Python static type checking
        
        -- Debugging
        "debugpy",     -- Python debugger adapter
        
        -- Testing
        -- Note: pytest is installed via pip, not Mason
        
        -- Formatters
        "stylua",      -- Lua
        "prettier",    -- Web development
      },
      
      ---@type boolean Automatically update installed tools
      auto_update = true,
      
      ---@type boolean Run installation on Neovim startup
      run_on_start = true,
      
      ---@type number Delay in milliseconds before starting installation
      start_delay = 3000,
      
      ---@type table Debounce settings for automatic updates
      debounce_hours = 24,
    })
  end,
}