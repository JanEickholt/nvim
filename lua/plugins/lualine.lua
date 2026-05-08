return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local function lsp_clients()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if #clients == 0 then
				return ""
			end

			local names = {}
			for _, client in ipairs(clients) do
				names[#names + 1] = client.name
			end

			return table.concat(names, ",")
		end

		require("lualine").setup({
			options = {
				globalstatus = true,
				section_separators = "",
				component_separators = "|",
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					{
						"filename",
						path = 1,
						symbols = {
							modified = "[+]",
							readonly = "[ro]",
							unnamed = "[No Name]",
						},
					},
				},
				lualine_x = {
					{ "diagnostics", sources = { "nvim_diagnostic" } },
					lsp_clients,
					"filetype",
				},
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
		})
	end,
}
