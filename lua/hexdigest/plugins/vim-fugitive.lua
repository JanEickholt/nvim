return {
  "tpope/vim-fugitive",
  config = function()
    vim.keymap.set("n", "<leader>GG", "<cmd>Git<CR>")
    vim.keymap.set("n", "<leader>GC", "<cmd>Git commit<CR>")
    vim.keymap.set("n", "<leader>GP", "<cmd>Git push<CR>")
    vim.keymap.set("n", "<leader>Gp", "<cmd>Git pull<CR>")
    vim.keymap.set("n", "<leader>Gd", "<cmd>Gvdiffsplit!<CR>")
  end,
}
