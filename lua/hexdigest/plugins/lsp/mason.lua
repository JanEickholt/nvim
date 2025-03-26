return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	config = function()
		require("mason").setup()

		require("mason-lspconfig").setup({
			automatic_installation = true,
			ensure_installed = {},
		})

		require("mason-tool-installer").setup({
			ensure_installed = {
				"typescript-language-server",
				"gopls",
				"dockerls",
				"svelte-language-server",
				"tailwindcss-language-server",
				"jdtls",
				"texlab",
				"intelephense",
				"clangd",
				"pyright",
				"lua-language-server",

				-- Formatters
				"prettierd",
				"stylua",
				"black",
				"clang-format",
				"pretty-php",
				"rustfmt",
				"goimports",

				-- Linters
				"pylint",
				"phpcs",
				"trivy",

				-- Debuggers
				"codelldb",
				"debugpy",
			},
		})
	end,
}
