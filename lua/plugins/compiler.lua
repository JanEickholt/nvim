return {
  "Zeioth/compiler.nvim",
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
  keys = {
    { "<leader>co", "<cmd>CompilerOpen<cr>",          desc = "Open Compiler" },
    { "<leader>ct", "<cmd>CompilerToggleResults<cr>", desc = "Open Compiler" },
  },
  dependencies = {
    {
      "stevearc/overseer.nvim",
      cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
      opts = {
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          default_detail = 1,
        },
      },
    },
  },
  opts = {},
}
