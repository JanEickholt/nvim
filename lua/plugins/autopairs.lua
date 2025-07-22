return {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
  config = function()
    local npairs = require("nvim-autopairs")

    npairs.setup({
      disable_filetype = { "TelescopePrompt", "vim" },
    })

    vim.keymap.set("i", "jk", function()
      local row, col = unpack(vim.api.nvim_win_get_cursor(0))
      local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
      local total_lines = #lines

      local closing_chars = { '"', "'", ")", "}", "]", "`" }

      local function is_whitespace(char)
        return char:match("%s") ~= nil
      end

      local current_row, current_col = row, col + 1

      while current_row <= total_lines do
        local line = lines[current_row] or ""

        for i = current_col, #line do
          local char = line:sub(i, i)

          if not is_whitespace(char) then
            for _, closing_char in ipairs(closing_chars) do
              if char == closing_char then
                vim.api.nvim_win_set_cursor(0, { current_row, i })
                return
              end
            end
            break
          end
        end

        current_row = current_row + 1
        current_col = 1

        if current_row > row + 10 then
          break
        end
      end

      vim.api.nvim_feedkeys("jk", "n", false)
    end, { desc = "Jump out of autopairs (skips whitespace) or insert jk" })
  end,
}
