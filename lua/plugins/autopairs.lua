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
      local line = vim.api.nvim_get_current_line()

      local next_char = line:sub(col + 1, col + 1)
      local closing_chars = { '"', "'", ")", "}", "]", "`" }

      for _, char in ipairs(closing_chars) do
        if next_char == char then
          vim.api.nvim_win_set_cursor(0, { row, col + 1 })
          return
        end
      end

      vim.api.nvim_feedkeys("jk", "n", false)
    end, { desc = "Jump out of autopairs or insert jk" })
  end,
}
