return {
  "anuvyklack/windows.nvim",
  dependencies = {
    "anuvyklack/middleclass",
    "anuvyklack/animation.nvim",
  },
  config = function()
    vim.o.winwidth = 10
    vim.o.winminwidth = 10
    vim.o.equalalways = false
    require("windows").setup()
    vim.keymap.set("n", "<leader>wm", "<cmd>WindowsMaximize<cr>", { desc = "Maximize window" })
    vim.keymap.set("n", "<leader>we", "<cmd>WindowsEqualize<cr>", { desc = "Equalize windows" })
  end,
}
