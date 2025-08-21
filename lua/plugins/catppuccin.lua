return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function()
    require("catppuccin").setup({
      transparent_background = true, -- Enable transparency
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        neo_tree = true,
      },
    })
    
    -- Theme selection - uncomment one of the following lines to set your preferred theme
    -- vim.cmd.colorscheme("tokyonight-night")
    -- vim.cmd.colorscheme("rose-pine")
    -- vim.cmd.colorscheme("kanagawa")
    -- vim.cmd.colorscheme("dracula")
    vim.cmd.colorscheme("catppuccin")
    
    -- Available TokyoNight variants: tokyonight, tokyonight-night, tokyonight-storm, tokyonight-moon, tokyonight-day
    -- Available Rose Pine variants: rose-pine, rose-pine-main, rose-pine-moon, rose-pine-dawn
    -- Available Kanagawa variants: kanagawa, kanagawa-wave, kanagawa-dragon, kanagawa-lotus
  end,
}
