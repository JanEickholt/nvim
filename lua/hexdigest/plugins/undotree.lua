return {
  "mbbill/undotree",
  keys = {
    {
      "<leader>ut",
      function()
        vim.cmd.UndotreeToggle()
        vim.cmd.UndotreeFocus()
      end,
      desc = "Toggle UndoTree",
    },
  },
}
