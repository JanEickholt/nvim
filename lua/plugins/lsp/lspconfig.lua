return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
	},
	config = function()
		local lspconfig = vim.lsp.config
		local on_attach = function(client, bufnr)
			vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
			local opts = { noremap = true, silent = true, buffer = bufnr }
			local keymap = vim.keymap.set

			keymap("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
			keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Go to declaration" }))
			keymap(
				"n",
				"gi",
				vim.lsp.buf.implementation,
				vim.tbl_extend("force", opts, { desc = "Go to implementation" })
			)
			keymap("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "Find references" }))
			keymap(
				"n",
				"gy",
				vim.lsp.buf.type_definition,
				vim.tbl_extend("force", opts, { desc = "Go to type definition" })
			)

			keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover documentation" }))
			keymap("n", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature help" }))

			keymap("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code actions" }))
			keymap("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename symbol" }))

			keymap(
				"n",
				"<leader>wa",
				vim.lsp.buf.add_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "Add workspace folder" })
			)
			keymap(
				"n",
				"<leader>wr",
				vim.lsp.buf.remove_workspace_folder,
				vim.tbl_extend("force", opts, { desc = "Remove workspace folder" })
			)
			keymap("n", "<leader>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, vim.tbl_extend("force", opts, { desc = "List workspace folders" }))

			keymap("n", "[d", function()
				vim.diagnostic.jump({ count = -1, float = true })
			end, vim.tbl_extend("force", opts, { desc = "Previous diagnostic" }))
			keymap("n", "]d", function()
				vim.diagnostic.jump({ count = 1, float = true })
			end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
			keymap(
				"n",
				"<leader>cd",
				vim.diagnostic.open_float,
				vim.tbl_extend("force", opts, { desc = "Line diagnostics" })
			)

			if client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
				keymap("n", "<leader>uh", function()
					local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr })
					vim.lsp.inlay_hint.enable(not enabled, { bufnr = bufnr })
				end, vim.tbl_extend("force", opts, { desc = "Toggle inlay hints" }))
			end
		end

		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		lspconfig("ts_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
			root_markers = { { "nx.json", "angular.json", "package.json" }, ".git" },
		})
		vim.lsp.enable("ts_ls")

		lspconfig("angularls", {
			on_attach = on_attach,
			capabilities = capabilities,
			root_markers = { { "nx.json", "angular.json" }, ".git" },
			on_new_config = function(new_config, _)
				local project_root = new_config.root_dir
				local ngls_path = project_root .. "/node_modules/@angular/language-server"
				new_config.cmd = {
					"node",
					ngls_path .. "/bin/ngserver",
					"--stdio",
					"--tsProbeLocations",
					project_root,
					"--ngProbeLocations",
					project_root,
				}
			end,
		})
		-- vim.lsp.enable("angularls")

		lspconfig("cssls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("cssls")

		lspconfig("html", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("html")

		lspconfig("lua_ls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("lua_ls")

		lspconfig("pyright", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("pyright")

		local clangd_capabilities = vim.deepcopy(capabilities)
		clangd_capabilities.offsetEncoding = { "utf-16" }
		lspconfig("clangd", {
			on_attach = on_attach,
			capabilities = clangd_capabilities,
		})
		vim.lsp.enable("clangd")

		lspconfig("intelephense", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("intelephense")

		lspconfig("texlab", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("texlab")

		lspconfig("tailwindcss", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("tailwindcss")

		lspconfig("svelte", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("svelte")

		lspconfig("dockerls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("dockerls")

		lspconfig("gopls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("gopls")

		lspconfig("jdtls", {
			on_attach = on_attach,
			capabilities = capabilities,
		})
		vim.lsp.enable("jdtls")
	end,
}
