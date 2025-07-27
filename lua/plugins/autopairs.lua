return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")

    npairs.setup({
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    npairs.add_rules({
      Rule("$", "$", { "tex", "latex" }),
    })

    npairs.add_rules({
      Rule("<", ">", { "html", "typescript", "typescriptreact", "javascriptreact" }),
    })

    vim.keymap.set("i", "jk", function()
      local luasnip = require("luasnip")
      if luasnip.in_snippet() and luasnip.jumpable(1) then
        luasnip.jump(1)
        return
      end

      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local total_lines = #lines
      local closing_chars = { '"', "'", ")", "}", "]", "`", ">", "$" }

      -- Multi-character sequences to handle specially
      local multi_char_sequences = { '"""', "'''", "```" }

      local function is_whitespace(char)
        return char:match("%s") ~= nil
      end

      -- Check for multi-character sequences first
      local function check_multi_char_at_pos(line, pos)
        for _, seq in ipairs(multi_char_sequences) do
          if pos + #seq - 1 <= #line then
            local substr = line:sub(pos, pos + #seq - 1)
            if substr == seq then
              return #seq
            end
          end
        end
        return nil
      end

      local current_row, current_col = row, col + 1
      while current_row <= total_lines do
        local line = lines[current_row] or ""
        local i = current_col
        while i <= #line do
          local char = line:sub(i, i)
          if not is_whitespace(char) then
            -- Check for multi-character sequences first
            local multi_len = check_multi_char_at_pos(line, i)
            if multi_len then
              vim.api.nvim_win_set_cursor(0, { current_row, i + multi_len - 1 })
              return
            end

            -- Check for single closing characters
            for _, closing_char in ipairs(closing_chars) do
              if char == closing_char then
                vim.api.nvim_win_set_cursor(0, { current_row, i })
                return
              end
            end
            break
          end
          i = i + 1
        end
        current_row = current_row + 1
        current_col = 1
        if current_row > row + 10 then
          break
        end
      end

      vim.api.nvim_feedkeys("jk", "n", false)
    end, { desc = "LuaSnip jump or jump out of autopairs (including multi-char) or insert jk" })
  end,
}
