return {
  {
     'nvim-telescope/telescope.nvim', tag = '0.1.8',       
     dependencies = { 'nvim-lua/plenary.nvim' },
     config = function()
       local builtin = require("telescope.builtin")
       local themes = require("telescope.themes")
       
       require("telescope").setup({
         defaults = themes.get_dropdown({
           winblend = 10,
           width = 0.8,
           prompt_title = "Command Palette",
           results_title = "Results",
           preview_title = "Preview",
         })
       })
       
       vim.keymap.set('n', '<C-p>', builtin.find_files, {})    
       vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
     end
  },
  {
    'nvim-telescope/telescope-ui-select.nvim',
    config = function()
      require("telescope").setup({
      extensions = {
        ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          } 
        }
      }
    })
      require("telescope").load_extension("ui-select")
  end
  },
}
