return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "nvim-neotest/nvim-nio",
    "rcasia/neotest-java",
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-java")({
          incremental_build = true,
          jvm_args = { "-Xmx2G" },
          -- Manually specify JUnit jar (already downloaded)
          junit_jar = vim.fn.stdpath("data") .. "/neotest-java/junit-platform-console-standalone-1.10.2.jar",
        }),
      },
      -- Output configuration
      output = {
        open_on_run = "short",
      },
      -- Quickfix configuration
      quickfix = {
        open = false,
      },
      -- Status virtual text
      status = {
        virtual_text = true,
      },
      -- Summary configuration
      summary = {
        follow = true,
        expand_errors = true,
      },
    })
  end,
  keys = {
    { "<leader>tt", function() require("neotest").run.run() end, desc = "Run nearest test" },
    { "<leader>tT", function() require("neotest").run.run(vim.fn.expand("%")) end, desc = "Run current file tests" },
    { "<leader>td", function() require("neotest").run.run({ strategy = "dap" }) end, desc = "Debug nearest test" },
    { "<leader>ts", function() require("neotest").summary.toggle() end, desc = "Toggle test summary" },
    { "<leader>to", function() require("neotest").output.open({ enter = true }) end, desc = "Show test output" },
    { "<leader>tO", function() require("neotest").output_panel.toggle() end, desc = "Toggle output panel" },
    { "<leader>tS", function() require("neotest").run.stop() end, desc = "Stop test run" },
    { "[t", function() require("neotest").jump.prev({ status = "failed" }) end, desc = "Jump to previous failed test" },
    { "]t", function() require("neotest").jump.next({ status = "failed" }) end, desc = "Jump to next failed test" },
  },
}