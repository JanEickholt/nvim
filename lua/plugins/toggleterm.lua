return {
	"akinsho/toggleterm.nvim",
	version = "*",
	keys = {
		{
			"<leader>\\",
			"<cmd>ToggleTerm direction=float<cr>",
			desc = "Toggle terminal",
		},
	},
	opts = {
		direction = "float",
		shade_terminals = false,
		float_opts = {
			border = "rounded",
		},
		on_open = function(term)
			vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], { buffer = term.bufnr, desc = "Exit terminal mode" })
		end,
	},
}
