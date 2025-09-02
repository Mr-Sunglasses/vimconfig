return {
  {
    "ray-x/go.nvim",
    dependencies = {
      "ray-x/guihua.lua",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("go").setup()
    end,
    ft = "go",
  },
}
