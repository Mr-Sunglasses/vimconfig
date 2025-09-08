---@class NullLsConfig
---@field sources table

local M = {}

---Setup null-ls with formatting and linting sources
---@param null_ls table null-ls module
local function setup_sources(null_ls)
  null_ls.setup({
    sources = {
      -- Lua
      null_ls.builtins.formatting.stylua,
      
      -- Web development
      null_ls.builtins.formatting.prettier,
      
      -- C/C++
      null_ls.builtins.formatting.clang_format.with({
        extra_args = { "--style='{IndentWidth: 2, TabWidth: 2, UseTab: Never}'" },
      }),
      
      -- Additional Python linting (ruff handles formatting via LSP)
      null_ls.builtins.diagnostics.flake8,
      
      -- Note: Python formatting (black, isort, ruff) is handled by ruff LSP
      -- Ruff provides both linting and formatting through the language server
    },
    
    -- Format on save configuration
    on_attach = function(client, bufnr)
      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          group = vim.api.nvim_create_augroup("NullLsFormatting", { clear = true }),
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end
    end,
  })
end

---Setup keymaps for formatting
local function setup_keymaps()
  -- Format file or selection
  vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, { 
    desc = "Format code" 
  })
  
  -- Format and save
  vim.keymap.set("n", "<leader>gF", function()
    vim.lsp.buf.format()
    vim.cmd("write")
  end, { desc = "Format and save" })
end

return {
  "nvimtools/none-ls.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    local null_ls = require("null-ls")
    setup_sources(null_ls)
    setup_keymaps()
  end,
}