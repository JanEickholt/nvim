return {
  dir = vim.fn.stdpath("config") .. "/lua/opencode",
  name = "opencode.nvim",
  keys = {
    {
      "<leader>ol",
      function()
        require("opencode").send_line()
      end,
      mode = "n",
      desc = "OpenCode: send line ref",
    },
    {
      "<leader>os",
      function()
        require("opencode").send_selection()
      end,
      mode = "v",
      desc = "OpenCode: send selection ref",
    },
  },
  config = function()
    require("opencode").setup()
  end,
}
