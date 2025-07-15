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
      { "<leader>n", group = "Annotate", icon = { icon = "󰈙" } },
      { "<leader>G", group = "Git", icon = { icon = "󰊢", hl = "DevIconGitLogo" }, mode = { "n", "v" } },
      { "<leader>c", group = "Compiler", icon = { icon = "" } },
      { "<leader>r", group = "Refactor", mode = { "n", "v" } },
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
