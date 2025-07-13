return {
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		enabled = true,
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		lazy = true,
		event = { "BufReadPost", "BufNewFile" },
	},
	{
		"nvim-treesitter/nvim-treesitter",
		enabled = true,
		build = ":TSUpdate",
		event = "VeryLazy",
		config = function()
			local ts_repeat_move = require("nvim-treesitter.textobjects.repeatable_move")
			vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)
			vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
			vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })

			require("nvim-treesitter.configs").setup({
				modules = {},
				sync_install = false,
				ignore_install = {},
				auto_install = true,
				ensure_installed = {
					"lua",
					"python",
				},
				highlight = {
					enable = true,
					additional_vim_regex_highlighting = false,
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "v<CR>",
						node_incremental = "<CR>",
						node_decremental = "<BS>",
						scope_incremental = "<TAB>",
					},
				},
				textobjects = {
					move = {
						enable = true,
						goto_next_start = {
							["]f"] = { query = "@function.outer", desc = "Next function start" },
							["]c"] = { query = "@class.outer", desc = "Next class start" },
							["]a"] = { query = "@parameter.inner", desc = "Next parameter" },
							["]n"] = { query = "@number.inner", desc = "Next number" },
							["]w"] = { query = "@call.outer", desc = "Next call" },
							["]j"] = { query = "@attribute.inner", desc = "Next attribute" },
							["]U"] = { query = "@comment.inner", desc = "Next comment" },
							["]i"] = { query = "@conditional.outer", desc = "Next conditional" },
							["]o"] = { query = "@loop.outer", desc = "Next loop" },
							["]z"] = { query = "@function_name", desc = "Next function name" },
							["]x"] = { query = "@method_name", desc = "Next method name" },
							["]e"] = { query = "@call_name", desc = "Next call name" },
							["]h"] = { query = "@return_type", desc = "Next return type" },
							["]p"] = { query = "@function_parameters", desc = "Next params" },
							["]m"] = { query = "@variable.member.inner", desc = "Next member" },
							["]R"] = { query = "@return.inner", desc = "Next return" },
							["]'w"] = { query = "@call.inner", desc = "Next call inner" },
						},
						goto_next_end = {
							["]F"] = { query = "@function.outer", desc = "Next function end" },
							["]C"] = { query = "@class.outer", desc = "Next class end" },
							["]A"] = { query = "@parameter.inner", desc = "Next parameter end" },
							["]N"] = { query = "@number.inner", desc = "Next number end" },
							["]W"] = { query = "@call.outer", desc = "Next call end" },
							["]J"] = { query = "@attribute.inner", desc = "Next attribute end" },
							["]u"] = { query = "@comment.inner", desc = "Next comment end" },
							["]I"] = { query = "@conditional.outer", desc = "Next conditional end" },
							["]O"] = { query = "@loop.outer", desc = "Next loop end" },
							["]Z"] = { query = "@function_name", desc = "Next function name end" },
							["]X"] = { query = "@method_name", desc = "Next method name end" },
							["]E"] = { query = "@call_name", desc = "Next call name end" },
							["]H"] = { query = "@return_type", desc = "Next return type end" },
							["]P"] = { query = "@function_parameters", desc = "Next params end" },
							["]'R"] = { query = "@return.inner", desc = "Next return end" },
						},
						goto_previous_start = {
							["[f"] = { query = "@function.outer", desc = "Prev. function start" },
							["[c"] = { query = "@class.outer", desc = "Prev. class start" },
							["[a"] = { query = "@parameter.inner", desc = "Prev. parameter" },
							["[n"] = { query = "@number.inner", desc = "Prev. number" },
							["[w"] = { query = "@call.outer", desc = "Prev. call" },
							["[j"] = { query = "@attribute.inner", desc = "Prev. attribute" },
							["[U"] = { query = "@comment.inner", desc = "Prev. comment" },
							["[i"] = { query = "@conditional.outer", desc = "Prev. conditional" },
							["[o"] = { query = "@loop.outer", desc = "Prev. loop" },
							["[z"] = { query = "@function_name", desc = "Prev. function name" },
							["[x"] = { query = "@method_name", desc = "Prev. method name" },
							["[e"] = { query = "@call_name", desc = "Prev. call name" },
							["[h"] = { query = "@return_type", desc = "Prev. return type" },
							["[p"] = { query = "@function_parameters", desc = "Prev. params" },
							["[m"] = { query = "@variable.member.inner", desc = "Prev. member" },
							["[R"] = { query = "@return.inner", desc = "Prev. return" },
						},
						goto_previous_end = {
							["[F"] = { query = "@function.outer", desc = "Prev. function end" },
							["[C"] = { query = "@class.outer", desc = "Prev. class end" },
							["[A"] = { query = "@parameter.inner", desc = "Prev. parameter end" },
							["[N"] = { query = "@number.inner", desc = "Prev. number end" },
							["[W"] = { query = "@call.outer", desc = "Prev. call end" },
							["[J"] = { query = "@attribute.inner", desc = "Prev. attribute end" },
							["[u"] = { query = "@comment.inner", desc = "Prev. comment end" },
							["[I"] = { query = "@conditional.outer", desc = "Prev. conditional end" },
							["[O"] = { query = "@loop.outer", desc = "Prev. loop end" },
							["[Z"] = { query = "@function_name", desc = "Prev. function name end" },
							["[X"] = { query = "@method_name", desc = "Prev. method name end" },
							["[E"] = { query = "@call_name", desc = "Prev. call name end" },
							["[H"] = { query = "@return_type", desc = "Prev. return type end" },
							["[P"] = { query = "@function_parameters", desc = "Prev. params end" },
							["['R"] = { query = "@return.inner", desc = "Prev. return end" },
						},
					},
					lsp_interop = {
						enable = true,
						border = "rounded",
						floating_preview_opts = {},
						peek_definition_code = {
							["<leader>pf"] = "@function.outer",
							["<leader>pc"] = "@class.outer",
						},
					},
				},
			})
		end,
	},
}
