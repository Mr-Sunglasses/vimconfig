return {
  {
    "xiyaowong/transparent.nvim",
    config = function()
      require("transparent").setup({
        groups = { -- table: default groups
          'Normal', 'NormalNC', 'Comment', 'Constant', 'Special', 'Identifier',
          'Statement', 'PreProc', 'Type', 'Underlined', 'Todo', 'String', 'Function',
          'Conditional', 'Repeat', 'Operator', 'Structure', 'LineNr', 'NonText',
          'SignColumn', 'CursorLineNr', 'EndOfBuffer',
        },
        extra_groups = {
          "NormalFloat", -- plugins which have float panel such as Lazy, Mason, LspInfo
          "NvimTreeNormal", -- NvimTree
          "TelescopeNormal",
          "TelescopeBorder",
          "TelescopePromptBorder",
          "TelescopeResultsBorder",
          "TelescopePreviewBorder",
          "FloatBorder",
        },
        exclude_groups = {}, -- table: groups you don't want to clear
      })
      
      -- Enable transparency by default
      require("transparent").clear_prefix("BufferLine")
      require("transparent").clear_prefix("NeoTree")
      
      -- Keybinding to toggle transparency
      vim.keymap.set("n", "<leader>tt", ":TransparentToggle<CR>", { desc = "Toggle transparency" })
    end,
  }
}