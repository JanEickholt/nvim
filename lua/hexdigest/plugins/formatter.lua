return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "prettier_d" },
        typescript = { "prettier_d" },
        javascriptreact = { "prettier_d" },
        typescriptreact = { "prettier_d" },
        css = { "prettier_d" },
        html = { "prettier_d" },
        json = { "prettier_d" },
        yaml = { "prettier_d" },
        lua = { "stylua" },
        python = { "black" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        php = { "pretty-php" },
        rust = { "rustfmt" },
        java = { "clang-format" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
