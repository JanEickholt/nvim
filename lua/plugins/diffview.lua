return {
  "sindrets/diffview.nvim",
  enabled = true,
  keys = {
    { "<leader>gov", "<cmd>DiffviewOpen<cr>",          desc = "DiffView" },
    { "<leader>goh", mode = { "n" },                   "<cmd>DiffviewFileHistory<cr>", desc = "File history" },
    { "<leader>goh", mode = { "v" },                   ":DiffviewFileHistory<cr>",     desc = "Lines history" },
    { "<leader>got", "<cmd>DiffviewFileHistory %<cr>", desc = "This file history" },
  },
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory", "DiffviewLog" },
  config = function()
    -- For reference, default highlight group values
    -- DiffviewFilePanelInsertions = {
    --   default = true,
    --   link = "diffAdded",
    -- }
    --
    -- diffAdded = {
    --   bg = "#273849",
    --   fg = "#B8DB87",
    -- }
    -- DiffviewFilePanelDeletions = {
    --   default = true,
    --   link = "diffRemoved",
    -- }
    --
    -- diffRemoved = {
    --   bg = "#3A273A",
    --   fg = "#E26A75",
    -- }
    -- DiffviewStatusModified = {
    --   default = true,
    --   link = "diffChanged",
    -- }
    --
    -- DiffviewStatusCopied = {
    --   default = true,
    --   link = "diffChanged",
    -- }
    --
    -- DiffviewStatusRenamed = {
    --   default = true,
    --   link = "diffChanged",
    -- }
    --
    -- diffChanged = {
    --   bg = "#252A3F",
    --   fg = "#7CA1F2",
    -- }

    vim.api.nvim_set_hl(0, "DiffviewFilePanelInsertions", { fg = "#B8DB87", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusAdded", { fg = "#B8DB87", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusUntracked", { fg = "#B8DB87", bg = "NONE" })

    vim.api.nvim_set_hl(0, "DiffviewFilePanelDeletions", { fg = "#E26A75", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusBroken", { fg = "#E26A75", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusDeleted", { fg = "#E26A75", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusUnknown", { fg = "#E26A75", bg = "NONE" })

    vim.api.nvim_set_hl(0, "DiffviewStatusModified", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusCopied", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusRenamed", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusUnmerged", { fg = "#7CA1F2", bg = "NONE" })
    vim.api.nvim_set_hl(0, "DiffviewStatusTypeChange", { fg = "#7CA1F2", bg = "NONE" })

    vim.api.nvim_set_hl(0, "DiffviewFilePanelTitle", { link = "@markup.heading.1.markdown" })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelCounter", { link = "@markup.heading.1.markdown" })
    vim.api.nvim_set_hl(0, "DiffviewFilePanelSelected", { link = "@variable.parameter" })

    local actions = require("diffview.actions")
    local default_wrap_state = vim.o.wrap
    local default_cursorline_state = vim.o.cursorline
    local diff_sanitize = require("scripts.ui.diff-sanitize")

    vim.api.nvim_create_autocmd("User", {
      pattern = "DiffviewClose",
      callback = function()
        vim.o.wrap = default_wrap_state
        vim.o.cursorline = default_cursorline_state
      end,
    })

    -- FIX: might not be needed if not using recent switch to vim.lsp.config syntax

    -- -- Prevent powershell_es mess
    -- vim.api.nvim_create_autocmd("LspAttach", {
    --   callback = function(args)
    --     local bufnr = args.buf

    --     local client = vim.lsp.get_client_by_id(args.data.client_id)
    --     local name = vim.api.nvim_buf_get_name(bufnr)
    --     if client and client.name == "powershell_es" and name:match("^diffview://") then
    --       ---@diagnostic disable-next-line: param-type-mismatch -- go fuck yourself
    --       client.stop(client.name)
    --     end
    --   end,
    -- })

    require("diffview").setup({
      hooks = {
        --- @ diagnostic disable-next-line: unused-local
        view_opened = function(view)
          default_wrap_state = vim.o.wrap
          default_cursorline_state = vim.o.cursorline
          diff_sanitize.disable_diff_features()

          -- Name tabpage with diffview info
          vim.schedule(function()
            local tabpage = vim.api.nvim_get_current_tabpage()
            vim.api.nvim_create_autocmd("User", {
              pattern = "DiffviewDiffBufWinEnter",
              callback = function()
                if vim.api.nvim_get_current_tabpage() == tabpage then
                  local filename = vim.fn.expand("%:t")
                  if filename ~= "" and filename ~= "null" then
                    vim.t.custom_tabname = "diffview: " .. filename
                  end
                end
              end,
            })
          end)
        end,
        view_closed = function()
          diff_sanitize.re_enable_diff_features()
        end,
        --- @ diagnostic disable-next-line: unused-local
        diff_buf_read = function(bufnr)
          -- Assure cleanup of potential winbar breadcrumbs residues
          for _, win in ipairs(vim.api.nvim_list_wins()) do
            vim.wo[win].winbar = ""
          end
          if vim.opt_local.wrap ~= false or vim.opt_local.cursorline ~= false then
            vim.opt_local.wrap = false
            vim.opt_local.cursorline = false
          end
        end,
        diff_buf_win_enter = function(bufnr, winid, ctx)
          if ctx.layout_name:match("^diff2") then
            if ctx.symbol == "a" then
              vim.opt_local.winhl = table.concat({
                "DiffAdd:DiffviewDiffAddAsDelete",
                "DiffDelete:DiffviewDiffDelete",
              }, ",")
            elseif ctx.symbol == "b" then
              vim.opt_local.winhl = table.concat({
                "DiffDelete:DiffviewDiffDelete",
              }, ",")
            end
          end
        end,
      },
      ehnanced_diff_hl = true,
      keymaps = {
        view = {
          { "n", "q", actions.close,              { desc = "Close diffview" } },
          { "n", "-", actions.toggle_stage_entry, { desc = "Toggle stage file" } },
          {
            "n",
            "<C-j>",
            function()
              local cur_pos = vim.api.nvim_win_get_cursor(0)
              vim.cmd("normal! ]c")
              vim.cmd("normal! zz")
              local new_pos = vim.api.nvim_win_get_cursor(0)
              if cur_pos[1] == new_pos[1] and cur_pos[2] == new_pos[2] then
                local last_change_pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd("normal! G")
                local eof_pos = vim.api.nvim_win_get_cursor(0)
                if last_change_pos[1] == eof_pos[1] and last_change_pos[2] == eof_pos[2] then
                  actions.select_next_entry()
                end
              end
            end,
            { desc = "Next change or file" },
          },
          {
            "n",
            "<C-k>",
            function()
              local cur_pos = vim.api.nvim_win_get_cursor(0)
              vim.cmd("normal! [c")
              vim.cmd("normal! zz")
              local new_pos = vim.api.nvim_win_get_cursor(0)
              if cur_pos[1] == new_pos[1] and cur_pos[2] == new_pos[2] then
                local first_change_pos = vim.api.nvim_win_get_cursor(0)
                vim.cmd("normal! gg")
                local bof_pos = vim.api.nvim_win_get_cursor(0)
                if first_change_pos[1] == bof_pos[1] and first_change_pos[2] == bof_pos[2] then
                  actions.select_prev_entry()
                end
              end
            end,
            { desc = "Previous change or file" },
          },
        },
        file_panel = {
          { "n", "q", actions.close,              { desc = "Close diffview" } },
          { "n", "s", false,                      { desc = "diffview_ignore" } }, -- lets us use flash in diffview
          { "n", "-", actions.toggle_stage_entry, { desc = "Toggle stage file" } },
        },
        file_history_panel = {
          { "n", "q", actions.close, { desc = "Close diffview" } },
        },
      },
    })
  end,
}
