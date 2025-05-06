vim.g.mapleader = " "

vim.opt.scrolloff = 8
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("x", "<leader>p", '"_dP')
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y')
vim.keymap.set({ "n", "v" }, "<leader>d", '"_d')

-- Make Y work like D or C
vim.keymap.set("n", "Y", "y$")

-- Stop cc, x, and X from overwriting default register
vim.keymap.set("n", "cc", '"_cc')
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "X", '"_X')

-- Paste in visual mode without overwriting default register
vim.keymap.set("v", "p", "P")

vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("v", "<leader>i", "g<C-a>")

vim.keymap.set({ "i", "n", "v" }, "<C-C>", "<esc>", { desc = "Make Ctrl+C behave exactly like escape." })
