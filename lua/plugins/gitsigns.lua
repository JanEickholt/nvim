return {
	"lewis6991/gitsigns.nvim",
	enabled = true,
	event = { "BufReadPost", "BufNewFile" },
	commit = "3c76f7fabac723aa682365ef782f88a83ccdb4ac", -- Locked for now due to Windows issues  TODO: Check upstream

	opts = {
		-- Define signs for unstaged changes
		signs = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
			untracked = { text = "▎" },
		},

		-- Define signs for staged changes
		signs_staged = {
			add = { text = "▎" },
			change = { text = "▎" },
			delete = { text = "" },
			topdelete = { text = "" },
			changedelete = { text = "▎" },
		},

		--- @diagnostic disable-next-line: unused-local
		on_attach = function(buffer)
			local gs = package.loaded.gitsigns
			local diff_sanitize = require("scripts.ui.diff-sanitize")

			-- Helper function for mapping keys
			local function map(mode, l, r, desc)
				vim.keymap.set(mode, l, r, { desc = desc, silent = true })
			end

			-- Show old code that was removed as "deleted" in diff view
			-- vim.schedule(function()
			for _, winid in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
				local bufnr = vim.api.nvim_win_get_buf(winid)
				local bufname = vim.api.nvim_buf_get_name(bufnr)

				-- Check if this is the "old" version (index/HEAD)
				if bufname:match("^gitsigns://") then
					vim.api.nvim_set_option_value("winhl", "DiffAdd:DiffDelete,DiffDelete:DiffDelete", { win = winid })
				end
			end
			-- end)

			-- Helper function for setting tab-specific keymaps
			local function set_diff_tab_keymaps(new_tab, created_buffers)
				local diff_tab_nr = vim.api.nvim_tabpage_get_number(new_tab)

				map("n", "q", function()
					vim.cmd("tabclose")
				end)

				-- close diff tab and jump to current change position
				map("n", "Q", function()
					local cursor_pos = vim.api.nvim_win_get_cursor(0)
					local current_file = vim.api.nvim_buf_get_name(0)

					vim.cmd("tabclose")

					-- Jump to the same position in the previous tab if it's the same file
					vim.schedule(function()
						local prev_buf_name = vim.api.nvim_buf_get_name(0)
						if current_file == prev_buf_name then
							vim.api.nvim_win_set_cursor(0, cursor_pos)
							vim.cmd("normal! zz")
						end
					end)
				end, "Close diff tab")

				map("n", "<C-k>", function()
					vim.cmd.normal({ "[c", bang = true })
					vim.cmd("normal! zz")
				end, "Next change in diff")

				map("n", "<C-j>", function()
					vim.cmd.normal({ "]c", bang = true })
					vim.cmd("normal! zz")
				end, "Previous change in diff")

				vim.api.nvim_create_autocmd("TabClosed", {
					callback = function(args)
						diff_sanitize.re_enable_diff_features()
						local closed_tab_nr = tonumber(args.file)
						if closed_tab_nr == diff_tab_nr then
							require("modules.gitsigns.restore-bindings").restore_gs_bindings()

							-- Clean up the created buffers
							for _, buf in ipairs(created_buffers or {}) do
								if vim.api.nvim_buf_is_valid(buf) then
									-- Check if buffer is empty and unnamed
									local buf_name = vim.api.nvim_buf_get_name(buf)
									local buf_lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
									local is_empty = #buf_lines == 1 and buf_lines[1] == ""
									local is_unnamed = buf_name == ""

									if is_empty and is_unnamed then
										vim.api.nvim_buf_delete(buf, { force = true })
									end
								end
							end
						end
					end,
				})
			end

			-- Buffer operations
			map("n", "<leader>gS", gs.stage_buffer, "Stage Buffer")
			map("n", "<leader>gR", gs.reset_buffer, "Reset Buffer")

			-- Blame operations
			map("n", "<leader>gb", function()
				gs.blame_line({ full = true })
			end, "Blame Line")

			map("n", "<leader>gB", function()
				gs.blame()
			end, "Blame Buffer")

			---@param base? string
			local function create_diff_tab(base)
				local original_buf = vim.api.nvim_get_current_buf()
				local buffers_before = vim.api.nvim_list_bufs()

				vim.cmd("tabnew")
				vim.cmd("buffer #")
				local filename = vim.fn.expand("%:t")
				local head_suffix = base and ("(" .. base .. ")") or ""
				vim.t.custom_tabname = "gs diff" .. head_suffix .. ": " .. filename
				gs.diffthis(base)
				diff_sanitize.disable_diff_features()

				local buffers_after = vim.api.nvim_list_bufs()
				local created_buffers = {}

				-- Find newly created buffers
				for _, buf in ipairs(buffers_after) do
					local found = false
					for _, old_buf in ipairs(buffers_before) do
						if buf == old_buf then
							found = true
							break
						end
					end
					if not found and buf ~= original_buf then
						table.insert(created_buffers, buf)
					end
				end

				local new_tab = vim.api.nvim_get_current_tabpage()
				set_diff_tab_keymaps(new_tab, created_buffers)
			end

			-- Diff operations in new tab
			map("n", "<leader>gd", function()
				create_diff_tab(nil)
			end, "Quick diff in new tab")
		end,
	},
}
