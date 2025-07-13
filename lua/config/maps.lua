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

-- Delete whole word with ctrl+backspace (interpreted as <C-h> in terminal)
vim.keymap.set("i", "<C-BS>", "<C-w>", { desc = "Delete word backward" })

-- Rebind macro key cause mistakes are made too often lol
vim.keymap.set("n", "q", "", { desc = "Disabled (use Q for macros)" })
vim.keymap.set("n", "Q", "q", { desc = "Record macro" })

-- Center after most code navigation commands
vim.keymap.set("n", "G", "Gzz", { desc = "Go to end and center" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
vim.keymap.set("n", "<C-O>", "<C-O>zz", { desc = "Jump back and center" })
vim.keymap.set("n", "<C-I>", "<C-I>zz", { desc = "Jump forward and center" })
vim.keymap.set("n", "{", "{zz", { desc = "Previous paragraph and center" })
vim.keymap.set("n", "}", "}zz", { desc = "Next paragraph and center" })
vim.keymap.set("n", "n", "nzz", { desc = "Next search and center" })
vim.keymap.set("n", "N", "Nzz", { desc = "Previous search and center" })
vim.keymap.set("n", "*", "*zz", { desc = "Search word under cursor and center" })
vim.keymap.set("n", "#", "#zz", { desc = "Search word under cursor backward and center" })
vim.keymap.set("n", "%", "%zz", { desc = "Match bracket and center" })
