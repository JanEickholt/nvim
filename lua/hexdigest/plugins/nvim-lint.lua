return {
  "mfussenegger/nvim-lint",
  config = function()
    require("lint").linters_by_ft = {
      python = { "pylint" },
      php = { "phpcs" },
      go = { "trivy" },
      c = { "trivy" },
      cpp = { "trivy" },
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })

    -- Set pylint to work in virtualenv
    require("lint").linters.pylint.cmd = "python"
    require("lint").linters.pylint.args = { "-m", "pylint", "-f", "json" }
  end,
}
