return {
	"sindrets/diffview.nvim",
	keys = {
		{
			"<leader>dfo",
			function()
				require("diffview").open()
			end,
			desc = "Open diff view",
		},
		{
			"<leader>dfc",
			function()
				require("diffview").close()
			end,
			desc = "Open diff view",
		},
	},
}
