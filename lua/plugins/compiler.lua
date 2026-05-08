return {
  "Zeioth/compiler.nvim",
  cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
  keys = {
    { "<leader>co", "<cmd>CompilerOpen<cr>",          desc = "Open Compiler" },
    { "<leader>ct", "<cmd>CompilerToggleResults<cr>", desc = "Toggle Compiler Results" },
  },
  opts = {},
  dependencies = {
    {
      "stevearc/overseer.nvim",
      cmd = { "OverseerRun", "OverseerToggle", "OverseerOpen", "OverseerClose" },
      keys = {
        { "<leader>or", "<cmd>OverseerRun<cr>",    desc = "Run Overseer Task" },
        { "<leader>ot", "<cmd>OverseerToggle<cr>", desc = "Toggle Overseer" },
      },
      opts = {
        task_list = {
          direction = "bottom",
          min_height = 25,
          max_height = 25,
          default_detail = 1,
        },
        -- Ensure user templates are loaded from lua/overseer/template/user/
        templates = { "builtin", "user" },
      },
    },
  },
}
