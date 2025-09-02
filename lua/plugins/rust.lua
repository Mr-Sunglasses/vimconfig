return {
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "mfussenegger/nvim-dap",
    },
    config = function()
      local rt = require("rust-tools")
      rt.setup({
        server = {
          on_attach = function(_, bufnr)
            vim.lsp.buf.hover()
            vim.lsp.buf.definition()
            vim.lsp.buf.code_action()
            vim.keymap.set("n", "<leader>gf", vim.lsp.buf.format, { buffer = bufnr })
          end,
        },
      })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    ft = "rust",
    config = function()
      local null_ls = require("null-ls")
      null_ls.setup({
        sources = {
          null_ls.builtins.formatting.rustfmt,
        },
      })
    end,
  },
}
