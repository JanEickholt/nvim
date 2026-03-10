return {
  "stevearc/oil.nvim",
  init = function()
    require("oil").setup({
      default_file_explorer = true,
      columns = {
        "icon",
      },
      view_options = {
        show_hidden = true,
      },
      float = {
        border = "rounded",
        win_options = {
          winblend = 0,
          wrap = true,
        },
      },
    })
  end,
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
