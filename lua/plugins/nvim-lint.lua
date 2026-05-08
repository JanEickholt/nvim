return {
  "mfussenegger/nvim-lint",
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      python = { "pylint" },
      php = { "phpcs" },
    }

    -- Try to detect the correct python executable
    local python_exe = vim.fn.exepath("python3") ~= "" and "python3" or vim.fn.exepath("python") ~= "" and "python" or nil

    if python_exe then
      lint.linters.pylint.cmd = python_exe
      lint.linters.pylint.args = { "-m", "pylint", "-f", "json" }
    else
      -- Disable pylint if no python executable is found
      lint.linters_by_ft.python = {}
    end

    -- Check if phpcs is available, disable if not
    if vim.fn.exepath("phpcs") == "" then
      lint.linters_by_ft.php = {}
    end

    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave" }, {
      callback = function()
        local ft = vim.bo.filetype
        local linters = lint.linters_by_ft[ft]
        if linters and #linters > 0 then
          local ok, err = pcall(lint.try_lint)
          if not ok then
            vim.notify("Lint error: " .. tostring(err), vim.log.levels.WARN)
          end
        end
      end,
    })
  end,
}
