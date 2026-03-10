vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.clipboard = "unnamedplus"
vim.opt.wrap = false
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = vim.fn.expand("~/.vim/undodir")
vim.opt.undofile = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 14
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50

-- Transparency for floating windows
vim.opt.winblend = 0 -- Floating window transparency (0 = full transparency)
vim.opt.pumblend = 0 -- Popup menu transparency (0 = full transparency)

-- formatting
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- search
vim.opt.smartcase = true
vim.opt.ignorecase = true

vim.opt.cursorline = true

-- line for column length
-- vim.opt.colorcolumn = "80"
