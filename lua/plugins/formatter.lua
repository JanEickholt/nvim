return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	keys = {
		{
			"<leader>cf",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			desc = "Format buffer",
		},
	},
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd" },
				typescript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescriptreact = { "prettierd" },
				svelte = { "prettierd" },
				css = { "prettierd" },
				html = { "prettierd" },
				htmlangular = { "prettierd" },
				json = { "prettierd" },
				yaml = { "prettierd" },
				lua = { "stylua" },
				python = { "black" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				php = { "pretty-php" },
				rust = { "rustfmt" },
				java = { "google-java-format" },
				go = { "goimports" },
				tex = { "latexindent" },
			},
			format_on_save = {
				lsp_format = "fallback",
				async = false,
				timeout_ms = 10000,
			},
		})
	end,
}
