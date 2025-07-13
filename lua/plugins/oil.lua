return {
  "stevearc/oil.nvim",
  init = function()
    require("oil").setup()
  end,
  opts = {},
  keys = {
    {
      "<leader>e",
      function()
        require("oil").open_float()
      end,
      desc = "open oil",
    },
  },
  -- Optional dependencies
  dependencies = { "nvim-tree/nvim-web-devicons" },
}
