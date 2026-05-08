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
      { "<leader>d", group = "debug/diff" },
      { "<leader>o", group = "tools" },
      { "<leader>q", group = "session" },
      { "<leader>t", group = "test" },
      { "<leader>u", group = "ui" },
      { "<leader>w", group = "window/workspace" },
      { "<leader>x", group = "lists" },
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
