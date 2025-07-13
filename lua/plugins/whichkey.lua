return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 200,
    spec = {
      -- ] and [ keybinds Alternatives
      { "]'", group = "Alternative next", icon = { icon = "⏭️" } },
      { "['", group = "Alternative previous", icon = { icon = "⏮️" } },

      { "<leader>f", group = "Telescope" },
    },
  },
  keys = {
    scroll_down = "<c-d>",
    scroll_up = "<c-u>",
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
}
