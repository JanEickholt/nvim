return {
	"folke/todo-comments.nvim",
	dependencies = { "nvim-lua/plenary.nvim" },
	opts = {},
	event = "VeryLazy",
	keys = {
		{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo list" },
	},
}
