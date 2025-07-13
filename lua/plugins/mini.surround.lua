return {
  "echasnovski/mini.surround",
  enabled = true,
  lazy = false,
  recommended = true,
  opts = {
    mappings = {
      add = "gsa",            -- Add surrounding in Normal and Visual modes
      delete = "gsd",         -- Delete surrounding
      find = "gsf",           -- Find surrounding (to the right)
      find_left = "gsF",      -- Find surrounding (to the left)
      highlight = "gsh",      -- Highlight surrounding
      replace = "gsr",        -- Replace surrounding
      update_n_lines = "gsn", -- Update `n_lines`
    },
  },
  config = function(_, opts)
    require("mini.surround").setup(opts)

    require("which-key").add({
      mode = { "n", "v" },
      { "gs", group = "Surround", icon = "" },
      { "gsa", desc = "Add surrounding" },
      { "gsd", desc = "Delete surrounding" },
      { "gsf", desc = "Find surrounding (right)" },
      { "gsF", desc = "Find surrounding (left)" },
      { "gsh", desc = "Highlight surrounding" },
      { "gsr", desc = "Replace surrounding" },
      { "gsn", desc = "Update n_lines" },
    })
  end,
}
