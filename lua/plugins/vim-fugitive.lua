return {
	"tpope/vim-fugitive",
	keys = {
		{ "<leader>GG", "<cmd>Git<CR>", desc = "Git status" },
		{ "<leader>GC", "<cmd>Git commit<CR>", desc = "Git commit" },
		{ "<leader>GP", "<cmd>Git push<CR>", desc = "Git push" },
		{ "<leader>Gp", "<cmd>Git pull<CR>", desc = "Git pull" },
		{ "<leader>Gd", "<cmd>Gvdiffsplit!<CR>", desc = "Git diff split" },
		{ "<leader>Gdg", "<cmd>diffget", desc = "Diff get" },
		{ "<leader>Gdp", "<cmd>diffput<CR>", desc = "Diff put" },
	},
}
