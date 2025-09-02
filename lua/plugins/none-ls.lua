return {
  "nvimtools/none-ls.nvim",
  config = function()
    local null_ls = require("null-ls")

    null_ls.setup({
      sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.clang_format.with({
          extra_args = { "--style='{IndentWidth: 2, TabWidth: 2, UseTab: Never}'" },
        }),
        
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>gf", vim.lsp.buf.format, {})
  end,
}
