return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
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
        json = { "prettierd" },
        yaml = { "prettierd" },
        lua = { "stylua" },
        python = { "black" },
        c = { "clang-format" },
        cpp = { "clang-format" },
        php = { "pretty-php" },
        rust = { "rustfmt" },
        java = { "clang-format" },
        go = { "goimports" },
        tex = { "latexindent" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 10000,
      },
    })

    vim.keymap.set({ "n", "v" }, "<leader>f", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 10000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
