return {
  "mfussenegger/nvim-dap-python",
  ft = "python",
  dependencies = { "mfussenegger/nvim-dap" },
  config = function()
    require("dap-python").setup("/home/user/.local/share/nvim/mason/packages/debugpy/venv/bin/python")
  end,
}
