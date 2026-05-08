vim.opt.guicursor = ""
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
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
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.isfname:append("@-@")
vim.opt.updatetime = 50
vim.opt.fillchars:append("eob: ")

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

-- line for column length
-- vim.opt.colorcolumn = "80"

vim.diagnostic.config({
	virtual_text = false,
	signs = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = "if_many",
	},
})

local function hide_env_secrets()
	vim.cmd("syntax on")

	vim.opt_local.conceallevel = 2
	vim.opt_local.concealcursor = "nvc"

	vim.cmd("silent! syntax clear SecretValue")

	-- only hide value, not key
	vim.cmd([[syntax match SecretValue /=\zs.*/ conceal cchar=*]])
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
	pattern = ".env*",
	callback = hide_env_secrets,
})
