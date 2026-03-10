return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        javascript = { "semistandard" },
        typescript = { "semistandard" },
        javascriptreact = { "semistandard" },
        typescriptreact = { "semistandard" },
        svelte = { "prettierd" },
        css = { "prettierd" },
        html = { "prettierd" },
        htmlangular = { "prettierd" },
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

    conform.formatters.semistandard = {
      command = "semistandard",
      args = { "--fix", "$FILENAME" },
      stdin = false,
      tempfile = true,
      exit_codes = { 0, 1 },
    }
  end,
}
